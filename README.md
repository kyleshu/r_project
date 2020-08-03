Augmented Dickey-Fuller Test

data:  GSPC_Close
Dickey-Fuller = -4.3109, Lag order = 11, p-value = 0.01
alternative hypothesis: stationary

Series: GSPC_Close 
ARIMA(5,1,5) 

Coefficients:
          ar1     ar2     ar3     ar4     ar5     ma1      ma2     ma3      ma4      ma5
      -0.4449  0.2537  0.0051  0.3784  0.7022  0.3029  -0.2152  0.1013  -0.4974  -0.6318
s.e.   0.0887  0.1195  0.1028  0.1109  0.0913  0.0845   0.1018  0.0819   0.0932   0.0675

sigma^2 estimated as 823.6:  log likelihood=-6700.55
AIC=13423.1   AICc=13423.29   BIC=13480.82

                   ME     RMSE      MAE        MPE      MAPE     MASE        ACF1
Training set 1.399043 28.58634 17.75854 0.04570811 0.7036977 1.000114 0.007602425

                   ME    RMSE      MAE        MPE      MAPE     MASE       ACF1
Training set 1.009629 29.8642 17.68834 0.03089519 0.7021478 0.996161 0.01207291