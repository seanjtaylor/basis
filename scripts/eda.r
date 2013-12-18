
library(plyr)
library(ggplot2)
library(lubridate)

##  load metrics
X <- read.csv('data/clean/metrics_10011210.csv')
X$minutes <- parse_date_time(as.character(X$minutes), '%y-%m-%d %H:%M:%S')


## sleep distribution
S <- read.csv('data/clean/states_10011210.csv')

S$start <- as.POSIXct(S$start, origin = "1970-01-01",tz = "GMT")
S$end <- as.POSIXct(S$end, origin = "1970-01-01",tz = "GMT")
S$day <- with(S, month(start)*100 + day(start))
S$duration <- with(S, end - start)

ggplot(subset(S, activity == 'sleep' & duration > 300),
       aes(x= as.numeric(duration))) + geom_histogram(binwidth=20)
