# GFS-R
A simple prototype R wrapper to access past weather forecasts from the Global Forecast System (GFS) data as housed in the National Digital Forecast System archive. 

## Set up

To use the wrapper, install `ncdf4` and `rvest`.

## Functions

### translateFields
Rather than haphazardly searching for data series codes to access GFS from a spreadsheet, simply use translateFields to get a dataframe with the necessary information. Choose from "snow","quant_precip", "tmin", "tmax", "skycover", "prob_precip", "wind_gust", "wind_speed", "rel_humidity","sig_wave_hgt", "dew_point"

```{r translateFields}
translateFields(vector)
```
 ### getForecast
Returns a dataframe of gridded forecasts. Inputs required: 
```{r translateFields}
getForecast(series, yyyymmdd, vintages = c(1,13), milestone = "00")
```
- series = is an object of data series as obtained from `translateFields()`
- yyyymmdd = a string value containing year, month and day for the day a model with run (not the forecast target date)
- vintages = Determines which model run to extract from the Thredds server as there there are 24 forecasts per day. Defaults to the 1st and 13th forecasts
- milestone = character value denoting desired hour for which a forecast is produced. Default is "00". For example: If the specified yyyymmdd is 9/10, then "00" would return 12am on 9/11. There is an exception:  if the series is tmin, getForecast() will return 12pm on 9/11 is returned due to the forecasting cycles

Fields are named based on the series name + reference hour (hours since) + time step since ref hour.


 
### getThreddsDir
(Support function) For a given day, obtain a list of all available files in the Thredds server. Input string containing Year, month and day (8 characters). 

```{r getThreddsDir}
getThreddsDir(yyyymmdd)
```
 


