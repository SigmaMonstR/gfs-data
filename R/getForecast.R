getForecast <- function(series, yyyymmdd, vintages = c(1), milestone = "00"){
  #
  # 
  # Args:
  #   yyyymmdd = a string value containing year, month and day for the day a model with run (not the forecast target date)
  #   series = dataframe of variable keys from the translateFields()
  #   vintages = which model run is used to calculate. There are 24 forecasts per day. Defaults are the 1st and 13th out of 24
  #   milestone = character value denoting target hour the following day. Default is "00". 
  #               For example: If the specified yyyymmdd is 9/10, then "00" would return 12am on 
  #               Except if the series is tmin, in which case 12pm on 9/11 is returned due to the forecasting cycles
  #
  # Returns:
  #   dataframe for specified period
  #               - Fields are named based on the series name + reference hour (hours since) + time step since ref hour
  #

  #Open libraries
  require(ncdf4)
  require(RCurl)
  
  #Get subdirectories from Thredds server
  url <- paste("https://www.ncei.noaa.gov/thredds/catalog/ndfd/file",substr(yyyymmdd,1,6), yyyymmdd,"catalog.html", sep = "/") 
  
  #Check to see if url exists
  if(url.exists(url)){
  
  folders <- readLines(url)
  
  #############################
  #ITERATE THROUGH EACH SERIES#
  #############################
  
    #set up dates
    year <- substr(yyyymmdd, 1,4)
    month <- substr(yyyymmdd, 5,6)
    day <- substr(yyyymmdd, 7,8)
    startDate <- as.Date(paste(year, month, day,sep = "/"), "%Y/%m/%d")
    endDate <- startDate + 1
    yyyymm <- paste0(year,month)
    
    #strings
    root <- "https://www.ncei.noaa.gov/thredds/ncss/ndfd/file"
    start_range <- paste0("&disableLLSubset=on&disableProjSubset=on&horizStride=1&time_start=",startDate,"T00%3A00%3A00Z&")
    end_range <- paste0("time_end=",endDate,"T12%3A00%3A00Z&timeStride=1&addLatLon=true")
    
    ##variable strings
    fcst <- as.data.frame(matrix(NA, nrow = 10000000, ncol = 0))
    for(i in 1:nrow(series)){
      for(j in vintages){
   
        codename <- as.character(series$code[i])
        seriesname <- series$name[i]
        series_24 <- regmatches(folders,regexpr(paste0(codename,"_",yyyymmdd,"\\d{4}"),folders))
        print(paste0("Series = ",seriesname," - ", "Vintage = ",j))
        
        
        #only progress if full series is found
        if(length(series_24)>=0){
          
          #Set up API Call
          varname <- unlist(getVarName(series_24[j]))
          print(varname)
          var_string <- paste0("?var=",varname)
          
          part <-paste0(var_string,"&north=50.1129&west=-130.1229&east=-60.8661&south=20.1786&disableLLSubset=on&disableProjSubset=on&horizStride=1&", start_range, end_range)
          url <- paste0(root, "/", yyyymm, "/", yyyymmdd, "/", series_24[j], part)
      
        #Download file and open Netcdf
        temp <- tempfile()
        download.file(url, temp)
        out <- nc_open(temp)
      
        #Extract values
        var_array <- ncvar_get(out, varname)
        lat <- ncvar_get(out,"lat")
        lon <- ncvar_get(out,"lon")
        time <- ncvar_get(out,"time")
      
        #Target time 
        raw_time <- gsub("Hour since ","",out$dim$time$units)
        bench_time <- strptime(raw_time, tz = "UTC", "%Y-%m-%dT%H:%M:%SZ")
        bench_hour <- format(bench_time, "%H")
        target_time <- strptime(paste0(as.character(startDate + 1),"T",milestone,":00:00Z"), tz = "UTC", "%Y-%m-%dT%H:%M:%SZ")
        
        
        # #Get bounding box
        # min_lat <- unlist(ncatt_get(out,0,"geospatial_lat_min")[2])
        # max_lat <- unlist(ncatt_get(out,0,"geospatial_lat_max")[2])
        # min_lon <- unlist(ncatt_get(out,0,"geospatial_lon_min")[2])
        # max_lon <- unlist(ncatt_get(out,0,"geospatial_lon_max")[2])
        
        #Create grid in decimals
        # lon_seq <- seq(min_lon, max_lon, (max_lon - min_lon)/(length(lon)-1))
        # lat_seq <- seq(min_lat, max_lat, (max_lat - min_lat)/(length(lat)-1))
        
        df <- data.frame(lat = as.vector(lat), lon = as.vector(lon))
        
        #convert to df
        if(length(time) >1){
          for(time_slice in 1:length(time)){
            vec <- as.vector(var_array[,,time_slice])
            vec[is.na(vec)] <- NA
            df <- cbind(df, vec)
          }
        } else {
          vec <- as.vector(var_array)
          vec[is.na(vec)] <- NA
          df <- cbind(df, vec)
        }
          
        new_name <- paste0(seriesname,".",bench_hour,".", time)
        colnames(df) <- c("lon","lat",new_name)
        df$model_date <- yyyymmdd
        
        #Set up merge
        if(ncol(fcst) == 0){
          fcst <- fcst[1:nrow(df),]
          fcst <- cbind(fcst, df)
        } else {
          fcst <- merge(fcst, df, by = c("lon","lat","model_date"))
        }
        }
      }
    }
   
  return(fcst)
  }
}



