library(quantmod)
library(tseries)
library(timeSeries)
library(forecast)
library(xts)

code <- "000300.ss"
code2<- "SHSZ300"

fn <- paste("log/", code2, ".txt", sep = "")
sink(fn, append=FALSE, split=TRUE)

somestock <- getSymbols(code, auto.assign = FALSE, 
                        from = "2015-01-01", to = "2020-07-01", 
                        src = "yahoo")
test_data <- getSymbols(code, auto.assign = FALSE, 
                        from = "2020-07-01", to = "2020-08-01", 
                        src = "yahoo")
term <- nrow(test_data)
fn <- paste("plots/", code2, "_barchart.jpg", sep = "")
jpeg(filename = fn)
barChart(somestock)
dev.off()

somestock_close <- somestock[,4]
fn <- paste("plots/", code2, "_close.jpg", sep = "")
jpeg(filename = fn)
plot(somestock_close)
dev.off()

fn <- paste("plots/", code2, "_acf+pacf.jpg", sep = "")
jpeg(filename = fn)
par(mfrow=c(1,2))
Acf(somestock_close, main='ACF for Differenced Series')
Pacf(somestock_close, main='PACF for Differenced Series')
dev.off()

print(adf.test(somestock_close))

fitA <- auto.arima(somestock_close, seasonal = FALSE)
print(fitA)
fn <- paste("plots/", code2, "_auto.jpg", sep = "")
jpeg(filename = fn)
tsdisplay(residuals(fitA), lag.max = 40, main='Auto Model Residuals')
dev.off()

fitB <- arima(somestock_close, order = c(1,1,1))
fn <- paste("plots/", code2, "_111.jpg", sep = "")
jpeg(filename = fn)
tsdisplay(residuals(fitB), lag.max = 40, main='(1,1,1) Model Residuals')
dev.off()

fn <- paste("plots/", code2, "_fcast_auto.jpg", sep = "")
jpeg(filename = fn)
fcast1 <- forecast(fitA, h=term)
plot(fcast1)
dev.off()

fn <- paste("plots/", code2, "_fcast_111.jpg", sep = "")
jpeg(filename = fn)
fcast2 <- forecast(fitB, h=term)
plot(fcast2)
dev.off()

accuracy(fcast1)
accuracy(fcast2)

sink()
