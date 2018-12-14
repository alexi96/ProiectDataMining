#####################
# Time series I: EDA #
#####################


        # 10. Some simple forecasting methods #

    # 10.1. Average method

y <- ts(c(123,39,78,52,110), start=2012) # y contains the time series
h = 10 # h is the forecast horizon
meanf(y, h)

    # 10.2. Na?ve method

y <- ts(c(123,39,78,52,110), start=2012) # y contains the time series
h = 10 # h is the forecast horizon
naive(y, h)
rwf(y, h) # Equivalent alternative

    # 10.3. Seasonal na?ve method

y <- ts(c(123,39,78,52,110), start=2012) # y contains the time series
h = 10 # h is the forecast horizon
snaive(y, h)

    # 10.4. Drift method

y <- ts(c(123,39,78,52,110), start=2012) # y contains the time series
h = 10 # h is the forecast horizon
rwf(y, h, drift=TRUE)

    # 10.5. Examples

# The Figure bellow shows the first three methods applied to the quarterly beer production data.

# Set training data from 1992 to 2007
beer2 <- window(ausbeer,start=1992,end=c(2007,4))
# Plot some forecasts
autoplot(beer2) +
  autolayer(meanf(beer2, h=11),
    series="Mean", PI=FALSE) +
  autolayer(naive(beer2, h=11),
    series="Na?ve", PI=FALSE) +
  autolayer(snaive(beer2, h=11),
    series="Seasonal na?ve", PI=FALSE) +
  ggtitle("Forecasts for quarterly beer production") +
  xlab("Year") + ylab("Megalitres") +
  guides(colour=guide_legend(title="Forecast"))

# The Figure bellow, the non-seasonal methods are applied to a series of 200 days of the Google daily closing stock price.

autoplot(goog200) +
  autolayer(meanf(goog200, h=40),
    series="Mean", PI=FALSE) +
  autolayer(rwf(goog200, h=40),
    series="Na?ve", PI=FALSE) +
  autolayer(rwf(goog200, drift=TRUE, h=40),
    series="Drift", PI=FALSE) +
  ggtitle("Google stock (daily ending 6 Dec 2013)") +
  xlab("Day") + ylab("Closing Price (US$)") +
  guides(colour=guide_legend(title="Forecast"))

        # 11. Transformations and adjustments

    # 11.1 Calendar adjustments

dframe <- cbind(Monthly = milk,
                DailyAverage = milk/monthdays(milk))
  autoplot(dframe, facet=TRUE) +
    xlab("Years") + ylab("Pounds") +
    ggtitle("Milk production per cow")

        # 11. Transformations and adjustments

    # 11.1 Calendar adjustments