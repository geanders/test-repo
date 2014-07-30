setwd("~/Downloads/")
ex <- readLines("20140709_1019_Oxycon_VENT.txt")

## Get rid of all the extra space at the start of each line.
ex <- gsub("^\\s+", "", ex)

## Get ID number
id.spot <- strsplit(ex[grep("Identification:", ex)], "\\s")
id <- id.spot[[1]][grep("[0-9]", id.spot[[1]])]

## Get values for different times of interest
important.times <- grep("General info field", ex)
imp.times.df <- data.frame(
        action = sub("General info field ", "", 
                     sub("\\s+$", "", ex[important.times])),
        place.in.ex = important.times
)

## It looks like the first value is the start time
start.time <-as.character(imp.times.df$action[1])
study.date <- "2014-07-09" ## I got this from the other dataset
start.time <- strptime(as.character(paste(study.date, start.time)),
                       format = "%Y-%m-%d %H:%M:%S")

## Make a dataset with just the ending times for different activities
end.times <- imp.times.df[grep("end_", imp.times.df$action),]
end.times$action <- gsub("end_", "", end.times$action)
end.times$time <- rep(NA)
for(i in 1:nrow(end.times)){
       ex.element <- ex[end.times$place.in.ex[i] - 1]
       ex.element <- unlist(strsplit(ex.element, split = " "))
       end.times$time[i] <- ex.element[1]
}
## Why are there doubles for some activities? Is it giving different times?
## Let's check. 
unique(end.times[,c("action", "time")])
## Nope, it looks like there's just one time for each. 
end.times <- unique(end.times[,c("action", "time")])
## Add the start time to each value to determine the clock time
## First, add extra zeros to make them all have a value in the hours spot
end.times$time <- ifelse(nchar(end.times$time) == 5,
                    paste0("0:",end.times$time),
                    end.times$time)
## Convert the times to "difftime"s
end.times$time <- as.difftime(end.times$time, "%H:%M:%S", units = "hour")
end.times$clock.time <- start.time + end.times$time

## Add these to the 'df' dataframe from the other file
## First, let's check for the rows that occur at these times
df[which(strptime(df$DateTime, format = "%Y-%m-%d %H:%M:%S") == 
           end.times$clock.time[1]),]
## Let's set up a variable for the last two minutes up to a stop of an action
df$action <- NA
for(i in 1:nrow(end.times)){
        stop.time <- end.times$clock.time[i]
        init.time <- stop.time - as.difftime("02", "%M", units = "mins")
        df.i <- which(df$DateTime >= init.time & 
                              df$DateTime <= stop.time)
        df$action[df.i] <- end.times$action[i]
}
df$action <- factor(df$action, levels = end.times$action)

## Create a reduced dataframe, just with these times (two minutes before the
## end of an action)
reduced.df <- df[!is.na(df$action),]

## Let's model some relationships
ggplot(reduced.df, aes(x = DateTime, y = Heart.Rate)) + geom_point() + 
        facet_grid(. ~ action, scales = "free_x") + 
        ggtitle("Heart Rate")
ggplot(reduced.df, aes(x = DateTime, y = Minute.Ventilation)) + geom_point() + 
        facet_grid(. ~ action, scales = "free_x") + 
        ggtitle("Minute Ventilation")
ggplot(reduced.df, aes(x = Heart.Rate, y = Minute.Ventilation)) + 
        geom_point(alpha = 0.4, 
                   position = position_jitter(width = 0.5, height = 1)) + 
        geom_smooth(method = lm) + 
        facet_wrap(~ action, ncol = 2, scales = "free") + 
        ggtitle("Heart Rate vs. Minute Ventilation")

ggplot(reduced.df, aes(x = Heart.Rate, y = Minute.Ventilation)) + 
        geom_point(alpha = 0.4, 
                   position = position_jitter(width = 0.5, height = 1)) + 
        geom_smooth(method = lm) + 
        facet_grid(. ~ action, scales = "free_x") + 
        ggtitle("Heart Rate vs. Minute Ventilation")

ggplot(reduced.df, aes(x = Heart.Rate, y = Minute.Ventilation, color = action)) + 
        geom_point(alpha = 0.4, 
                   position = position_jitter(width = 0.5, height = 1)) + 
        geom_smooth(method = lm) + 
        ggtitle("Heart Rate vs. Minute Ventilation")

ggplot(reduced.df, aes(x = Heart.Rate, y = Minute.Ventilation)) + 
        geom_point(alpha = 0.4, 
                   position = position_jitter(width = 0.5, height = 1)) + 
        geom_smooth(method = lm) + 
        ggtitle("Heart Rate vs. Minute Ventilation")
