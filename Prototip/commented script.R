#####################
# Time series I: EDA #
#####################


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
