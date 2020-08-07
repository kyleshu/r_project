library(quantmod)
library(tseries)
library(timeSeries)
library(forecast)
library(xts)
library(lubridate)

startDate <- ymd('2018-07-01')
endDate <- ymd('2018-08-01')
startDates <- startDate %m+% months(c(0:24))
endDates <- endDate %m+% months(c(0:24))

for (m in 1:length(startDates)) {

  fcast_start_date <- as.character(startDates[m])
  fcast_end_date <- as.character(endDates[m])
  
  # calculate forecasting days
  test_data <- getSymbols("603000.ss", auto.assign = FALSE, 
                          from = fcast_start_date, to = fcast_end_date, 
                          src = "yahoo")
  term <- nrow(test_data)
  
  # load CSI 300 stocks
  csi300 <- read.csv("data/csi300.csv", header = TRUE)
  
  # load CSI 300 stock price time series
  for (i in 1:nrow(csi300)) {
    data <- getSymbols(as.character(csi300[i,1]), auto.assign = FALSE, 
                       from = "2015-01-01", to = fcast_start_date, src = "yahoo")
    abbr <- as.character(csi300[i,2])
    assign(abbr, data[,4])
  }
  
  # use auto ARIMA model, and forecast 30-day yields
  df <- data.frame(Code=character(), 
                   Yield=double(), 
                   High=double(),
                   stringsAsFactors=FALSE) 
  for (i in 1:nrow(csi300)) {
    # retrieve data
    abbr <- as.character(csi300[i,2])
    data <- get(abbr)
    
    # generate model
    fit_model <- auto.arima(data, seasonal = TRUE)
    
    # forecast
    fcast <- forecast(fit_model, h=term)
    future_price <- fcast$mean[term]
    max_price <- max(fcast$mean)
    current_price <- as.double(data[length(data)])
    yield <- (future_price/current_price)-1
    high <- (max_price/current_price)-1
    df2 <- data.frame(abbr, yield, high)
    names(df2) <- c("Code", "Yield", "High")
    df <- rbind(df, df2)
  }
  
  # sort stocks and export
  df <- df[order(df$Yield, decreasing = TRUE),]
  write.csv(df, paste("result_auto_seasonal/", fcast_start_date, ".csv", sep = ""))
}
