

getVarName <- function(subdir){
  
  #
  # 
  # Args:
  #   subdir = subdirectory where data is held in Thredds server. This is one element returned by the getThreddsDir() folder
  #
  # Returns:
  #   vector containing variable name
  #
  
  require(XML)
  head1 <- "https://www.ncei.noaa.gov/thredds/wcs/ndfd/file"
  foot1 <- "?service=WCS&version=1.0.0&request=GetCapabilities"
  yyyymm <- substr(subdir, 13,18)
  yyyymmdd <- substr(subdir, 13,20)
  url <- paste(head1,yyyymm, yyyymmdd, subdir,foot1, sep = "/")
  a <- readLines(url)
  b <- xmlParse(a)
  xml_data <- xmlToList(b)
  var_name <- xml_data$ContentMetadata$CoverageOfferingBrief$name
  return(var_name)
}

getVarName("YSUZ98_KWBN_201304040052")
getVarName("YSUZ98_KWBN_201510050017")

