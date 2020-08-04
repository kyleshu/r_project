library(quantmod)
library(tseries)
library(timeSeries)
library(forecast)
library(xts)

somestock <- getSymbols("^GSPC", auto.assign = FALSE, from = "2015-01-01", 
           to = "2020-08-01", src = "yahoo")
barChart(somestock)

somestock_close <- somestock[,4]
plot(somestock_close)

par(mfrow=c(1,2))
Acf(somestock_close, main='ACF for Differenced Series')
Pacf(somestock_close, main='PACF for Differenced Series')

print(adf.test(somestock_close))

# 必要时进行差分
# df <- ndiffs(somestock_close, test = "adf")
# df_data <- diff(somestock_close, df)
# somestock_close <- df_data[(df+1):nrow(df_data),]

fitA <- auto.arima(somestock_close, seasonal = FALSE)
tsdisplay(residuals(fitA), lag.max = 40, main='(5,1,5) Model Residuals')

fitB <- arima(somestock_close, order = c(1,1,1))
tsdisplay(residuals(fitB), lag.max = 40, main='(1,1,1) Model Residuals')

term <- 100
fcast1 <- forecast(fitA, h=term)
plot(fcast1)
fcast2 <- forecast(fitB, h=term)
plot(fcast2)

accuracy(fcast1)
accuracy(fcast2)
