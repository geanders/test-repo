## Figure out what working directory you're in
getwd()

## Set your working directory to be the one for Week2_RProgramming (wherever
## you've put that on your computer). Note that your path might be different 
## from mine
setwd("~/test-repo/Week2_RProgramming/")

## Now you can use "list.files()" to list all the files in your current directory
list.files()

## We can use this to get the file names for all of the storms in 2005
list.files("HurrTracks2005/")

## Put all of these into their own vector, so we'll be able to cycle through 
## it in a loop
hurr.file.names <- list.files("HurrTracks2005/")
hurr.file.names

## Now we want to create a list that has an element for each storm. Let's 
## use the storm names from the file names, but take out everything after
## the dash. To figure out how to do this, I googled 
## "r remove everything in string after character"
storm.names <- gsub("-.*", "", hurr.file.names)

## Now we can create a list with an element for each storm. Right now everything
## will be blank, but we'll fill it up as we read in the files
hurr.paths <- vector(mode = "list", length = length(hurr.file.names))
names(hurr.paths) <- storm.names
head(hurr.paths, 3)

## Now let's check out the first file and figure out how we want to read it in
## First, let's use "paste" to create the file name for the first storm. By
## using "paste", it'll be easy later to loop through all the files
directory <- "HurrTracks2005/"
file.name <- paste0(directory, hurr.file.names[1])
file.name

## Now we can read the file for the first storm
df <- read.csv(file.name, header = TRUE, as.is = TRUE)
head(df)

## It looks like we might want to do a little bit of cleaning for the data.
## I'd suggest doing the following: getting "date" into a date-time format (notice
## that this "date" includes the time, hour and minute, too); and multiplying
## longitude by -1 (they're west longitudes, so they won't map right
## if they're positive). To do the date, I'll make sure I can get the call right
## before I put it in 'transform'.
head(strptime(df$date, format = "%Y%m%d%H%M")) ## Check ?strptime under Details
                                               ## to get all the abbreviations
                                               ## for format.
df <- transform(df,
          date = strptime(df$date, format = "%Y%m%d%H%M"),
          longitude = -1 * longitude
          )
head(df)

## Now that you have "date" in a date-time format, you can do things like subset
## out just the locations at midnight each day:
subset(df, format(date, "%H") == "00", select = c("date", "latitude", "longitude"))

## Now that we know, more or less what we want to do with our data when we 
## read it, we can do a loop to go through all the files.
## Notice that, where we put "[1]" before, to get the first storm, now we're 
## putting "[i]", so that on each loop it will get the ith storm. Check the code
## out first by setting it to 1 (i <- 1) and then going through the code inside
## the loop, then try out the whole loop.
for(i in 1:length(hurr.file.names)){
        print(storm.names[i]) ## I'll usually do this so I can see the 
                              ## progress of the loop when it's running
        directory <- "HurrTracks2005/"
        file.name <- paste0(directory, hurr.file.names[i])
        df <- read.csv(file.name, header = TRUE, as.is = TRUE)
        df <- transform(df,
                        date = strptime(df$date, format = "%Y%m%d%H%M"),
                        longitude = -1 * longitude
                        )
        hurr.paths[[i]] <- df ## Put the clean dataframe in the right slot 
                              ## of your 'hurr.paths' list
}

head(hurr.paths, 3)

## Just for fun, let's also try to read all the data into one big 
## dataframe, where we'll add a column called "storm" to put in the storm ID.
## We can use "rbind" to add on rows, as long as the dataframes have the same
## form (number, names, and types of columns). For the first file, (i == 1),
## we'll make the dataframe, then for other files, we'll add them on.

for(i in 1:length(hurr.file.names)){
        print(storm.names[i]) ## I'll usually do this so I can see the 
        ## progress of the loop when it's running
        directory <- "HurrTracks2005/"
        file.name <- paste0(directory, hurr.file.names[i])
        df <- read.csv(file.name, header = TRUE, as.is = TRUE)
        df <- transform(df,
                        date = strptime(df$date, format = "%Y%m%d%H%M"),
                        longitude = -1 * longitude
        )
        df$storm <- storm.names[i]
        if(i == 1){
                hurr.paths.df <- df 
        } else {
                hurr.paths.df <- rbind(hurr.paths.df, df)
        }
}

head(hurr.paths.df)

## with everything in the same dataframe, it's easy to do things like get the
## means or ranges of a value across all storms. For example, 
range(hurr.paths.df$latitude)
