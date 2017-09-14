
getThreddsDir <- function(yyyymmdd){
  #
  # Returns directory names associated with specific data series for specified days 
  #
  # Args:
  #   yyyymmdd = a string value containing year, month and day
  #   series = vector of variables as identified using translateFields()
  #
  # Returns:
  #   vector of variable names
  #
  print(paste0("Accessing directory for ",yyyymmdd))
  url <- paste("https://www.ncei.noaa.gov/thredds/catalog/ndfd/file",substr(yyyymmdd,1,6), yyyymmdd,"catalog.html", sep = "/") 
  thredds <- readLines(url)
  sets <- regmatches(thredds,regexpr(paste0(codename,"_",yyyymmdd,"\\d{4}"),thredds))
  print(paste0("Directories found for ",yyyymmdd))
  return(sets)
}


#EXAMPLE
# examp <- "20091201"
# multi_series <- c("YSUZ98_KWBN", "YZUZ88_KWBN")
# getThreddsDir(yyyymmdd = "20100910")