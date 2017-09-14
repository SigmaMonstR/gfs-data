#Get multiple series
  multi_series <- translateFields(c("snow","tmin","tmax", "quant_precip", "prob_precip"))

#Get forecasts produced on September 2, 2010 with a target of 0-hour on September 3
  test <- getForecast(series = multi_series, yyyymmdd = "20100902", vintages = c(1, 13), milestone = "00")
