
library(plyr)
library(ggplot2)
library(lubridate)

##  load metrics
X <- read.csv('data/clean/metrics_10011210.csv')
X$minutes <- parse_date_time(as.character(X$minutes), '%y-%m-%d %H:%M:%S')
