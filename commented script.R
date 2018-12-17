#####################
# Time series I: EDA #
#####################

library(forecast)
library(fpp2)

        # 1. Defining a ts object #

  # 1.1. Ts objects #

# We define a ts object using the ts function.
# The function's main arguments are:
# **data** = a vector or a matrix of observed time-series values.
# **start** = the time of the first observation, it can be a single number
#             or a vector of two integers
# **end** = the time of the last observation, specified in the same way as start
# **frequency** = the number of observations per unit of time, when used in R
#                 the following choices being recommended: 1, 4, 12, 52
#                 (anual, quarterly, monthly, weekly)
y <- ts(c(123,39,78,52,110), start=2012) 

y <- ts(z, start=2003, frequency=12)

        # 2. Time plots #

  # 2.1. Time plots #

# The **Autoplot()** command will be used frequently as it automattically produces an
# appropriate plot of whatever is passed as its first argument.
# **ggtitle()** command will set the title of the graph
# **xlab()** and **ylab()** commands will set the labels of the graph
autoplot(melsyd[,"Economy.Class"]) + # here the first argument is a time series object
  ggtitle("Economy class passengers: Melbourne-Sydney") +
  xlab("Year") +
  ylab("Thousands")


autoplot(a10) +
  ggtitle("Antidiabetic drug sales") +
  ylab("$ million") +
  xlab("Year")


      # 4. Seasonal plots #

# Seasonal plots are displayed in a similar way with time plots with the help of the
# ggseasonplot() function
# Main arguments:
# **x** = a numeric vector or time series
# **season.labels** = labels for each season of a year
# **year.labels** = a logical flag indicating wheter labels for each year of data should
#                   be plotted on the right 
# **year.labels.left** = same logic as previous argumet for the left side
# **col** = colour
# **polar** = plot the graph on seasonal coordinates


ggseasonplot(a10, year.labels=TRUE, year.labels.left=TRUE) +
  ylab("$ million") +
  ggtitle("Seasonal plot: antidiabetic drug sales")


ggseasonplot(a10, polar=TRUE) +
  ylab("$ million") +
  ggtitle("Polar seasonal plot: antidiabetic drug sales")


      # 5. Seasonal subseries plots #

# The seasonal subseries plots are displayed with the help of ggsubseriesplot function

ggsubseriesplot(a10) +
  ylab("$ million") +
  ggtitle("Seasonal subseries plot: antidiabetic drug sales")


      # 6. Scatterplots #


# Scatterplots are build with the autoplot() function

autoplot(elecdemand[,c("Demand","Temperature")], facets=TRUE) +
  xlab("Year: 2014") + ylab("") +
  ggtitle("Half-hourly electricity demand: Victoria, Australia")


# Use qplot to study relantionship between demand and temparature 
# Main arguments:
# **x, y, ...** = Aesthetics passed into each layer
# **data** = dataframe to use, if not specified, will create one, extracting vectors
#            from current environment

qplot(Temperature, Demand, data=as.data.frame(elecdemand)) +
  ylab("Demand (GW)") + xlab("Temperature (Celsius)")


  # 6.1. Scatterplots matrices #

autoplot(visnights[,1:5], facets=TRUE) + # visnights holding multiple predictors variables
  ylab("Number of visitor nights each quarter (millions)")

# GGally used for plotting the relationship between the time series, arranged in a scatterplot matrix

GGally::ggpairs(as.data.frame(visnights[,1:5]))


      # 7. Lag plots #

# To plot a lagplot we use gglagplot() function and window() function.
# Main arguments of gglagplot:
# **x** = a time series object
# **lags** = number of lag plots desired
# **diag** = logical indicating if the x=y diagonal should be drawn

# Window() is a generic function which extracts the subset of the object x between **start** and **end**
# Main arguments:
# **x** = a time series object
# **start** = the start time of the period of interest
# **end** = the end time of the period of interest

beer2 <- window(ausbeer, start=1992)
gglagplot(beer2)


      # 8. Autocorrelation #

ggAcf(beer2) # plots the autocorelation coefficients using the ACF function()

# We use the window() function and autoplot() function when data is both trended and seasonal
aelec <- window(elec, start=1980)
autoplot(aelec) + xlab("Year") + ylab("GWh")

ggAcf(aelec, lag=48) # plot Acf with 48 lags


      # 9. White noise #


set.seed(30) # set a reproductable sequence random result, in this case 30
y <- ts(rnorm(50)) # ts object of a 50 normal distribution
autoplot(y) + ggtitle("White noise") # plot the ts object

ggAcf(y) # plots the Acf of white noise, expected to lie between (+/-)(2/sqrt(T)). In this example T = 50.


		# 10. Some simple forecasting methods #

    # 10.1. Average method

y <- ts(c(123,39,78,52,110), start=2012) # y contains the time series
h = 10 # h is the forecast horizon
meanf(y, h)

    # 10.2. Naïve method

y <- ts(c(123,39,78,52,110), start=2012) # y contains the time series
h = 10 # h is the forecast horizon
naive(y, h)
rwf(y, h) # Equivalent alternative

    # 10.3. Seasonal naïve method

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
	
# For example, if you are studying the monthly milk production on a farm, there will be variation between the months simply because of the different numbers of days in each month, in addition to the seasonal variation across the year.
	
dframe <- cbind(Monthly = milk,
                DailyAverage = milk/monthdays(milk))
  autoplot(dframe, facet=TRUE) +
    xlab("Years") + ylab("Pounds") +
    ggtitle("Milk production per cow")

	# 11.2 Mathematical transformations
	
# A good value of λ is one which makes the size of the seasonal variation about the same across the whole series, as that makes the forecasting model simpler. In this case, λ=0.30 works quite well, although any value of λ between 0 and 0.5 would give similar results.

# The ```BoxCox.lambda()``` function will choose a value of lambda for you.

(lambda <- BoxCox.lambda(elec))
#> [1] 0.2654
autoplot(BoxCox(elec,lambda))
	
	# 11.3 Bias adjustments
	
# To see how much difference this bias-adjustment makes, consider the following example, where we forecast average annual price of eggs using the drift method with a log transformation (λ=0). The log transformation is useful in this case to ensure the forecasts and the prediction intervals stay positive.

fc <- rwf(eggs, drift=TRUE, lambda=0, h=50, level=80)
fc2 <- rwf(eggs, drift=TRUE, lambda=0, h=50, level=80,
  biasadj=TRUE)
autoplot(eggs) +
  autolayer(fc, series="Simple back transformation") +
  autolayer(fc2, series="Bias adjusted", PI=FALSE) +
  guides(colour=guide_legend(title="Forecast"))
  
		# 12. Residual diagnostics #
		
	# 12.1 Example: Forecasting the Google daily closing stock price
	
# The following graph shows the Google daily closing stock price (GOOG). The large jump at day 166 corresponds to 18 October 2013 when the price jumped 12% due to unexpectedly strong third quarter results.
	
autoplot(goog200) +
  xlab("Day") + ylab("Closing Price (US$)") +
  ggtitle("Google Stock (daily ending 6 December 2013)")
  
# The residuals obtained from forecasting this series using the naïve method are shown in Figure 3.6. The large positive residual is a result of the unexpected price jump at day 166.

res <- residuals(naive(goog200))
autoplot(res) + xlab("Day") + ylab("") +
  ggtitle("Residuals from naïve method")

gghistogram(res) + ggtitle("Histogram of residuals")

ggAcf(res) + ggtitle("ACF of residuals")

	# 12.2 Portmanteau tests for autocorrelation
	
# For the Google stock price example, the naïve model has no parameters, so K=0 in that case also.

# lag=h and fitdf=K
Box.test(res, lag=10, fitdf=0)
#> 
#>  Box-Pierce test
#> 
#> data:  res
#> X-squared = 11, df = 10, p-value = 0.4

Box.test(res,lag=10, fitdf=0, type="Lj")
#> 
#>  Box-Ljung test
#> 
#> data:  res
#> X-squared = 11, df = 10, p-value = 0.4

# All of these methods for checking residuals are conveniently packaged into one R function ```checkresiduals()```, which will produce a time plot, ACF plot and histogram of the residuals (with an overlaid normal distribution for comparison), and do a Ljung-Box test with the correct degrees of freedom.

checkresiduals(naive(goog200))

#> 
#>  Ljung-Box test
#> 
#> data:  Residuals from Naive method
#> Q* = 11, df = 10, p-value = 0.4
#> 
#> Model df: 0.   Total lags used: 10

		# 13. Evaluating forecast accuracy #

	# 13.1 Functions to subset a time series
	
# The window() function introduced in Chapter 2 is useful when extracting a portion of a time series, such as we need when creating training and test sets. In the ```window()``` function, we specify the start and/or end of the portion of time series required using time values. For example,

window(ausbeer, start=1995)
	
# Another useful function is subset() which allows for more types of subsetting. A great advantage of this function is that it allows the use of indices to choose a subset. For example:

subset(ausbeer, start=length(ausbeer)-4*5) # extracts the last 5 years of observations from ```ausbeer```. It also allows extracting all values for a specific season. For example,

subset(ausbeer, quarter = 1) # extracts the first quarters for all years.

# Finally, ```head``` and ```tail``` are useful for extracting the first few or last few observations. For example, the last 5 years of ```ausbeer``` can also be obtained using

tail(ausbeer, 4*5)

	# 13.2 Examples

beer2 <- window(ausbeer,start=1992,end=c(2007,4))
beerfit1 <- meanf(beer2,h=10)
beerfit2 <- rwf(beer2,h=10)
beerfit3 <- snaive(beer2,h=10)
autoplot(window(ausbeer, start=1992)) +
  autolayer(beerfit1, series="Mean", PI=FALSE) +
  autolayer(beerfit2, series="Naïve", PI=FALSE) +
  autolayer(beerfit3, series="Seasonal naïve", PI=FALSE) +
  xlab("Year") + ylab("Megalitres") +
  ggtitle("Forecasts for quarterly beer production") +
  guides(colour=guide_legend(title="Forecast"))

# The figure above shows three forecast methods applied to the quarterly Australian beer production using data only to the end of 2007. The actual values for the period 2008–2010 are also shown. We compute the forecast accuracy measures for this period.

beer3 <- window(ausbeer, start=2008)
accuracy(beerfit1, beer3)
accuracy(beerfit2, beer3)
accuracy(beerfit3, beer3)

# It is obvious from the graph that the seasonal naïve method is best for these data, although it can still be improved, as we will discover later. Sometimes, different accuracy measures will lead to different results as to which forecast method is best. However, in this case, all of the results point to the seasonal naïve method as the best of these three methods for this data set.

# To take a non-seasonal example, consider the Google stock price. The following graph shows the 200 observations ending on 6 Dec 2013, along with forecasts of the next 40 days obtained from three different methods.

googfc1 <- meanf(goog200, h=40)
googfc2 <- rwf(goog200, h=40)
googfc3 <- rwf(goog200, drift=TRUE, h=40)
autoplot(subset(goog, end = 240)) +
  autolayer(googfc1, PI=FALSE, series="Mean") +
  autolayer(googfc2, PI=FALSE, series="Naïve") +
  autolayer(googfc3, PI=FALSE, series="Drift") +
  xlab("Day") + ylab("Closing Price (US$)") +
  ggtitle("Google stock price (daily ending 6 Dec 13)") +
  guides(colour=guide_legend(title="Forecast"))

googtest <- window(goog, start=201, end=240)
accuracy(googfc1, googtest)
accuracy(googfc2, googtest)
accuracy(googfc3, googtest)

# Here, the best method is the drift method (regardless of which accuracy measure is used).

	# 13.3 Time series cross-validation
	
# Time series cross-validation is implemented with the tsCV() function. In the following example, we compare the RMSE obtained via time series cross-validation with the residual RMSE.
	
e <- tsCV(goog200, rwf, drift=TRUE, h=1)
sqrt(mean(e^2, na.rm=TRUE))
#> [1] 6.233
sqrt(mean(residuals(rwf(goog200, drift=TRUE))^2, na.rm=TRUE))
#> [1] 6.169

	# 13.4 Pipe operator

#The ugliness of the above R code makes this a good opportunity to introduce some alternative ways of stringing R functions together. In the above code, we are nesting functions within functions within functions, so you have to read the code from the inside out, making it difficult to understand what is being computed. Instead, we can use the pipe operator ```%>%``` as follows.
	
goog200 %>% tsCV(forecastfunction=rwf, drift=TRUE, h=1) -> e
e^2 %>% mean(na.rm=TRUE) %>% sqrt()
#> [1] 6.233
goog200 %>% rwf(drift=TRUE) %>% residuals() -> res
res^2 %>% mean(na.rm=TRUE) %>% sqrt()
#> [1] 6.169

	# 13.5 Example: using tsCV()

# The code below evaluates the forecasting performance of 1- to 8-step-ahead naïve forecasts with ```tsCV()```, using MSE as the forecast error measure. The plot shows that the forecast error increases as the forecast horizon increases, as we would expect.

e <- tsCV(goog200, forecastfunction=naive, h=8)
# Compute the MSE values and remove missing values
mse <- colMeans(e^2, na.rm = T)
# Plot the MSE values against the forecast horizon
data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = MSE)) + geom_point()

		# 14. Prediction intervals #
  
	# 14.1 Benchmark methods
	
# Prediction intervals will be computed for you when using any of the benchmark forecasting methods. For example, here is the output when using the naïve method for the Google stock price.

naive(goog200)
#>     Point Forecast Lo 80 Hi 80 Lo 95 Hi 95
#> 201          531.5 523.5 539.4 519.3 543.6
#> 202          531.5 520.2 542.7 514.3 548.7
#> 203          531.5 517.7 545.3 510.4 552.6
#> 204          531.5 515.6 547.4 507.1 555.8
#> 205          531.5 513.7 549.3 504.3 558.7
#> 206          531.5 512.0 551.0 501.7 561.3
#> 207          531.5 510.4 552.5 499.3 563.7
#> 208          531.5 509.0 554.0 497.1 565.9
#> 209          531.5 507.6 555.3 495.0 568.0
#> 210          531.5 506.3 556.6 493.0 570.0

# When plotted, the prediction intervals are shown as shaded region, with the strength of colour indicating the probability associated with the interval.

autoplot(naive(goog200))

	# 14.2 Prediction intervals from bootstrapped residuals
	
# To generate such intervals, we can simply add the bootstrap argument to our forecasting functions. For example:

naive(goog200, bootstrap=TRUE)
#>     Point Forecast Lo 80 Hi 80 Lo 95 Hi 95
#> 201          531.5 525.6 537.8 522.9 541.1
#> 202          531.5 523.0 539.4 519.5 546.2
#> 203          531.5 521.0 541.6 516.6 552.1
#> 204          531.5 519.4 543.4 514.1 566.7
#> 205          531.5 517.6 544.8 511.8 581.7
#> 206          531.5 516.2 546.8 509.8 583.4
#> 207          531.5 514.8 547.6 507.3 584.5
#> 208          531.5 513.2 549.5 505.8 587.7
#> 209          531.5 512.2 550.4 503.7 589.2
#> 210          531.5 510.7 551.7 502.1 591.3

# In this case, they are similar (but not identical) to the prediction intervals based on the normal distribution.

		# 15. The forecast package in R #
	
	# 15.1 Functions that output a forecast object:
			
# The following list shows all the functions that produce **forecast** objects.
# ```meanf()```
# ```naive()```, ```snaive()```
# ```rwf()```
# ```croston()```
# ```stlf()```
# ```ses()```
# ```holt()```, ```hw()```
# ```splinef()```
# ```thetaf()```
# ```forecast()```

  # 15.2 ```forecast()``` function

# Here is a simple example, applying ```forecast()``` to the ```ausbeer``` data:

forecast(ausbeer, h=4)
#>         Point Forecast Lo 80 Hi 80 Lo 95 Hi 95
#> 2010 Q3          404.6 385.9 423.3 376.0 433.3
#> 2010 Q4          480.4 457.5 503.3 445.4 515.4
#> 2011 Q1          417.0 396.5 437.6 385.6 448.4
#> 2011 Q2          383.1 363.5 402.7 353.1 413.1

# That works quite well if you have no idea what sort of model to use. But by the end of this book, you should not need to use ```forecast()``` in this “blind” fashion. Instead, you will fit a model appropriate to the data, and then use ```forecast()``` to produce forecasts from that model.
