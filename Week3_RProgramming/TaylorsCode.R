## Read in the data (I have it saved in my Downloads)
df <- read.csv("~/Downloads/20140709_1019_hexoskin_processed_VENT.csv",
               header = TRUE, as.is = TRUE)

## Check out the top, bottom, and dimensions of the data to make sure 
## it looks like things read in alright.
head(df)
tail(df)
dim(df) 
## You can compare the number of rows you get with dim() to the number of lines
## determined by using the command line call:
#### wc -l ~/Downloads/20140709_1019_hexoskin_processed_VENT.csv
## (where you put the file name on your computer at the end of the call)

## It seems like there are a lot of "DateTime" variables that are the same.
## If so, we can delete all but one. Let's check.
grep("DateTime", colnames(df))
identical(df[,1], df[,3])
identical(df[,1], df[,5])
identical(df[,1], df[,7])
identical(df[,1], df[,9])
df <- df[,-c(3, 5, 7, 9)]
head(df)

## Now let's get the remaining "DateTime" column in date-time format
class(df$DateTime)
df$DateTime[1] ## It seems like this has a funny ":199" at the end. Do
               ## all of them have this?
unique(substr(df$DateTime, 21, 23)) ## These are all the same, so let's take 
                                    ## them off.
df$DateTime <- substr(df$DateTime, 1, 19)
head(df$DateTime) ## Now we're ready to convert to date-time format
head(strftime(df$DateTime, format = "%Y-%m-%d %H:%M:%S", usetz = FALSE))
## Since that looks right, I'll change the dataset
df$DateTime <- strftime(df$DateTime, format = "%Y-%m-%d %H:%M:%S", usetz = FALSE)
head(df)

## Now let's check the data out. First, let's see how many missing values
## there are for each variable. 
sapply(df, function(x){ sum(is.na(x)) }) ## No missing values

## Next, let's see how many unique values there are for each variable. 
## Let's start with the date-- we'll want to make sure the days we have
## in the dataset are the same as the days we think we should have.
unique(strftime(df$DateTime, format = "%Y-%m-%d"))
## It looks like there are all for the same day. Is that right?
## Let's also look at the range of times during that day.
range(df$DateTime)
## So, this looks like measurements are from 11:40:15 in the morning to
## 12:51:39 in the afternoon. Again, does that sound right?
## Finally, are there all at one-second intervals? Let's check
unique(as.numeric(strftime(df$DateTime[2:nrow(df)], format = "%S")) - 
        as.numeric(strftime(df$DateTime[1:(nrow(df) - 1)], format = "%S")))
## This makes sense, and it looks like there are always increments of one second
## (The -59 is when you go from the 59th second of one minute to the 0th of 
## the next.)

## Now let's look at Heart.Rate. First, what are the unique values?
sort(unique(df$Heart.Rate))
## These range from 57 to 174 and seem to be spaced at 1-unit intervals.
## Does this make sense with what you think you know about the data? 
## Are the top and bottom values in the range realistic with physiology?
##Let's plot a histogram of these heart rates:
ggplot(df, aes(x = Heart.Rate)) + geom_histogram(binwidth = 20)
## Based on this, there are only a few heart rates in the 40-60 range
## (which makes sense, because the lowest heart rate is 57), then lots in
## the 60-80 and 80-100 ranges, and then decreasing amounts of higher 
## heart rates. Is this about what you expected?
## Now let's look at finer resolutions:
ggplot(df, aes(x = Heart.Rate)) + geom_histogram(binwidth = 10)
## Looking at these resolutions, there seem to be peaks and valleys. This is 
## a little weird-- sometimes it can be an indication that equipment
## tends to "stick" at certain values. Perhaps it's also that this is a mix
## of distributions... Let's look at some finer resolutions
ggplot(df, aes(x = Heart.Rate)) + geom_histogram(binwidth = 5)
ggplot(df, aes(x = Heart.Rate)) + geom_histogram(binwidth = 2)
ggplot(df, aes(x = Heart.Rate)) + geom_histogram(binwidth = 1)
## I would want to figure out why you're seeing these values. In particular,
## it's concerning that there's one value that's almost twice as common as any
## other single value (the tall spike when you do binwidth = 1). Let's figure
## out what value that is and look at that more closely.
table(as.factor(df$Heart.Rate)) ## Note-- I'm not changing Heart.Rate to a 
                                ## factor, just having "table" think of it as
                                ## a factor.
which.max(table(as.factor(df$Heart.Rate)))
100 * max(table(as.factor(df$Heart.Rate))) / nrow(df) ## This is about 7% of all observaations!
unique(strftime(df$DateTime[df$Heart.Rate == 122], format = "%H"))
## All of these readings were between 12 and 1 pm.
unique(strftime(df$DateTime[df$Heart.Rate == 122], format = "%M"))
## All were between the 35th and 51st minutes of 12 pm.
## Let's plot this period of time
check.hr <- subset(df, 
                   DateTime >= strftime("2014-07-09 12:35:00") &
                   DateTime <= strftime("2014-07-09 12:52:00"))
head(check.hr)
tail(check.hr) ## Notice that this is right at the end of the dataset...
ggplot(check.hr, aes(x = DateTime, y = Heart.Rate)) + geom_point() 
## Yep, that's not normal. You need to figure out what's going on and 
## clean up the data appropriately (maybe this was after the period you were
## actually measuring?)

## Let's try to plot the whole time series and see what else we see
ggplot(df, aes(x = DateTime, y = Heart.Rate)) + geom_point() 
## Some interesting things here: First, there's a steady pattern of increasing
## heart rate over the time of the data. Does this seem right? Second, there
## seems to be some periodic trends to the data (i.e., regular patterns at
## fixed intervals). Any idea why?
## Let's also look at this divided by 10-minute intervals
df$ten.mins <- paste(strftime(df$DateTime, format = "%H"),
                  sprintf("%02d", 10 * floor(as.numeric(strftime(df$DateTime, format = "%M"))/10)),
                  sep = ":")
unique(df$ten.mins)
df$ten.mins <- as.factor(df$ten.mins)
table(df$ten.mins)
ggplot(df, aes(x = (as.numeric(strftime(DateTime, format = "%M")) + 
                       as.numeric(strftime(DateTime, format = "%S")) / 60) -
                       as.numeric(substr(ten.mins, 4, 5)),
               y = Heart.Rate)) + 
        xlab("Time in interval") + 
        geom_point(size = 0.4) + 
        facet_grid(ten.mins ~ .)

## Now let's look at breathing rate
sort(unique(df$Breathing.Rate))
## Breathing rates are between 1 and 40. Does that sound right?
ggplot(df, aes(x = Breathing.Rate)) + geom_histogram(binwidth = 5)
## With broad categories, this looks pretty close to normal (although
## there are some more values between 0 and 5 than we might expect with 
## a normal distribution). Let's check a finer resolution.
ggplot(df, aes(x = Breathing.Rate)) + geom_histogram(binwidth = 1)
## Here, I find it interesting that there are a lot more values of "2" than we
## would expect and no values of 7 or 8... 
table(as.factor(df$Breathing.Rate))
## Let's look at a time series of these data:
ggplot(df, aes(x = DateTime, y = Breathing.Rate)) + geom_point()
## Again, two interesting things. First, something funny is definitely happening
## at the end of the data frame. Second, there seems to be some periodicity
## in the data, although not as strong as with the heart rate (there also seems
## to be more variability in the breathing rates than the heart rates).

## It looks like breathing and heart rates are following similar trends. Let's
## check the correlation:
with(df, cor(Heart.Rate, Breathing.Rate))
ggplot(df, aes(x = Heart.Rate, y = Breathing.Rate)) + geom_point()
with(subset(df, !(ten.mins %in% c("12:40", "12:50"))),
     cor(Heart.Rate, Breathing.Rate))
ggplot(subset(df, !(ten.mins %in% c("12:40", "12:50"))),
       aes(x = Heart.Rate, y = Breathing.Rate)) + geom_point()
## Except for the end of the dataset, these are very highly correlated.

## Now let's look at Minute.Ventilation
sort(unique(df$Minute.Ventilation))
length(sort(unique(df$Minute.Ventilation)))
nrow(df)
## This variable takes a lot of different values
head(sort(table(as.factor(df$Minute.Ventilation)), decreasing = TRUE))
## We might want to look out for times with these values-- are they all 
## in a row?

## Let's plot by time and check out the patterns
ggplot(df, aes(x = DateTime, y = Minute.Ventilation)) + geom_point()
## Again, something funky at the end. (Also, there are some zeros at the
## very beginning that probably aren't right.)
ggplot(subset(df, !(ten.mins %in% c("12:40", "12:50"))),
       aes(x = DateTime, y = Minute.Ventilation)) + geom_point()
## Before the end, it looks like similar trends to breathing rate and heart rate

## Now let's look at Activity
sort(unique(df$Activity))
head(sort(table(as.factor(df$Activity)), decreasing = TRUE))
## Zeros may be an issue here. Should there be so many?

## Let's plot the distribution
ggplot(df, aes(x = Activity)) + geom_histogram(binwidth = 0.01)
## Two interesting things: First, there are an unusual amount of zeros or 
## almost zeros. Second, the rest of the values have a long right tail, with
## a few observations with very high values.

## Let's look over time
ggplot(df, aes(x = DateTime, y = Activity)) + geom_point()
## Definitely some stuff here that you'll want to make sure is reasonable 
## with what was going on in the study. For example, near the beginning, there
## are long periods with zero / almost zero activity, but with quick spikes. 
## Later, at the end, there's a big spike in activity followed by a period of 
## zeros / almost zeros. There are clear periods in the activity. Finally, 
## some of the times activity seems to be much more variable than other times.

## Now let's look at Cadence
sort(unique(df$Cadence))
## Here, there's a big jump from 0 to the next lowest value. That suggests that 
## the zeros might not be right. 
head(sort(table(as.factor(df$Cadence)), decreasing = TRUE))
## Yep, I think those zeros definitely seem off.
ggplot(subset(df, Cadence != 0), aes(x = Cadence)) + 
        geom_histogram(binwidth = 1)
## For the rest of the values, there's a long right tail (a few extremely 
## high values) compared to what you'd expect with a normal distribution.
ggplot(df, aes(x = DateTime, y = Cadence)) + geom_point()
## This is another really interesting pattern-- there are zeros throughout, then
## occasion periods with some non-zeros. Does this data match what you think
## should be going on in your data based on your study? Also, why is there 
## such a big gap between 0 measurements and the next lowest value?

cadence.check <- subset(df, Cadence != 0)
with(cadence.check, cor(Activity, Cadence))
ggplot(cadence.check, aes(x = Activity, y = Cadence)) + geom_point()
