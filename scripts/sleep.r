library(ggplot2)
library(scales)

States <- read.csv('data/clean/states_10011230.csv')

Sleep <- subset(States, activity == 'sleep')
Sleep$start <- as.POSIXct(Sleep$start, origin = "1970-01-01", tz = "GMT")
Sleep$end <- as.POSIXct(Sleep$end, origin = "1970-01-01", tz = "GMT")
Sleep$date <- floor_date(Sleep$start, 'd')

# oof, why aren't there just *time* objects
# give them all the same arbitrary day
as.time <- function(dt) {
  hms(format(dt, format = '%H:%M:%S')) + ymd('2013-01-01')
}
Sleep$start.time <- with_tz(as.time(Sleep$start), 'America/Los_Angeles')
Sleep$end.time <- with_tz(as.time(Sleep$end), 'America/Los_Angeles')

p <- ggplot(Sleep, aes(xmin = date, xmax = date + hours(20), ymin = start.time, ymax = end.time))
p <- p + geom_rect() + scale_y_datetime(labels = date_format("%H:%M")) + xlab('Date') + ylab('Time')
