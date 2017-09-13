translateFields <- function(data_set){
  #
  # Converts vector of variable names into forecast series name
  #
  # Args:
  #   data_set = a vector of variables
  #
  # Returns:
  #   dataframe of forecast series names
  #
  
  lookup <- rbind(data.frame(a="snow",b="YSUZ98_KWBN",b="Total_snowfall_surface_6_Hour_Accumulation"),
                  data.frame(a="tmax",b="YGUZ98_KWBN",b="Maximum_temperature_surface_12_Hour_Maximum"),
                  data.frame(a="tmin",b="YHUZ98_KWBN",b="Minimum_temperature_surface_12_Hour_Minimum"),
                  data.frame(a="skycover",b="YAUZ98_KWBN",b="Total_cloud_cover_surface"),
                  data.frame(a="quant_precip",b="YIUZ98_KWBN",b="Total_precipitation_surface_6_Hour_Accumulation"),
                  data.frame(a="prob_precip",b="YDUZ98_KWBN",b="Total_precipitation_surface_12_Hour_Accumulation_probability_above_0p254"), 
                  data.frame(a="wind_gust",b="YWUZ98_KWBN",b="Wind_speed_gust_surface"),
                  data.frame(a="wind_speed",b="YCUZ98_KWBN",b="Wind_speed_surface"),
                  data.frame(a="rel_humidity",b="YRUZ98_KWBN",b="Relative_humidity_surface"),
                  data.frame(a="sig_wave_hgt",b="YKUZ98_KWBN",b="Significant_height_of_wind_waves_surface"),
                  data.frame(a="dew_point",b="YFUZ98_KWBN",b="Dewpoint_temperature_surface"))
    colnames(lookup) <- c("name","code","variable")
    lookup <- lookup[lookup$name %in% data_set, ]
    
  return(lookup)
}

