library(quantmod)
library(tseries)
library(timeSeries)
library(forecast)
library(xts)

fcast_start_date <- "2019-03-01"
fcast_end_date <- "2019-04-01"

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

# do ADF test on each stock
diff_order <- list()
for (i in 1:nrow(csi300)) {
  abbr <- as.character(csi300[i,2])
  data <- get(abbr)
  adf_result <- adf.test(data)
  pv <- adf_result$p.value
  
  # difference data according to ADF test
  df <- ndiffs(data, test = "adf")
  diff_order[abbr] <- df
}

# use AIC to determine best model and parameters, and forecast 30-day yields
p_list <- 0:5
q_list <- 0:5
df <- data.frame(Code=character(), 
                 Yield=double(), 
                 High=double(),
                 stringsAsFactors=FALSE) 
for (i in 1:nrow(csi300)) {
  abbr <- as.character(csi300[i,2])
  d <- as.double(diff_order[abbr])
  data <- get(abbr)
  best_model <- NULL
  min_aic <- Inf
  for (p in p_list) {
    for(q in q_list) {
      skip_to_next <- FALSE
      tryCatch(
        {
          this_model <- arima(data, order = c(p,d,q), method = "ML")
        },
        error=function(cond) {
          skip_to_next <- TRUE
        }
      )
      if (skip_to_next) next
      if (this_model$aic < min_aic) {
        best_model <- this_model
        min_aic <- this_model$aic
      }
    }
  }
  if (min_aic < Inf) {
    fcast <- forecast(best_model, h=term)
    future_price <- fcast$mean[term]
    max_price <- max(fcast$mean)
    current_price <- as.double(data[length(data)])
    yield <- (future_price/current_price)-1
    high <- (max_price/current_price)-1
    df2 <- data.frame(abbr, yield, high)
    names(df2) <- c("Code", "Yield", "High")
    df <- rbind(df, df2)
  }
}

# sort stocks and export
df <- df[order(df$Yield, decreasing = TRUE),]
write.csv(df, paste("result/", fcast_start_date, ".csv", sep = ""))
