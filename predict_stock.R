library(quantmod)
library(tseries)
library(timeSeries)
library(forecast)
library(xts)

hs300 <- read.csv("data/hs300.csv", header = TRUE)

for (i in 1:nrow(hs300)) {
  data <- getSymbols(as.character(hs300[i,1]), auto.assign = FALSE, 
                     from = "2015-01-01", to = "2020-08-01", src = "yahoo")
  abbr <- as.character(hs300[i,2])
  assign(abbr, data)
}

getSymbols("^GSPC", from = "2015-01-01", to = "2020-08-01", src = "yahoo")
barChart(GSPC)

GSPC_Close = GSPC[,4]
plot(GSPC_Close)

par(mfrow=c(1,2))
Acf(GSPC_Close, main='ACF for Differenced Series')
Pacf(GSPC_Close, main='PACF for Differenced Series')

print(adf.test(GSPC_Close))
auto.arima(GSPC_Close, seasonal = FALSE)

fitA = auto.arima(GSPC_Close, seasonal = FALSE)
tsdisplay(residuals(fitA), lag.max = 40, main='(5,1,5) Model Residuals')

fitB = arima(GSPC_Close, order = c(1,1,1))
tsdisplay(residuals(fitB), lag.max = 40, main='(1,1,1) Model Residuals')

term <- 100
fcast1 <- forecast(fitA, h=term)
plot(fcast1)
fcast2 <- forecast(fitB, h=term)
plot(fcast2)

accuracy(fcast1)
accuracy(fcast2)
