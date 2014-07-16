######################################################################
## Read in the FEMA data
######################################################################

## I originally got this data from FEMA's website. The only major
## change I've made to it is to add the FIPS number for each county
## and, when the declaration was 'statewide', I changed it to have 
## a separate row for each county in the state. 
fema <- read.csv("femaDeclarations.csv", header = TRUE, as.is = TRUE)

######################################################################
## Check out the dataset
######################################################################

str(fema)
summary(fema)
head(fema, 1) ## Since there are lots of columns, I'd only look at one 
              ## or two rows (try changing this to look at two rows)

######################################################################
## Clean up the data some
######################################################################

## The fips should always be five digits, even if the first digit is "0".
## So, let's change this to a character and add the leading zero if it's 
## missing. To figure out how to do this, I googled "R add leading zeros"
fema$fips <- sprintf("%05d", fema$fips)

## Now check out if that worked:
head(fema, 1)
class(fema$fips) ## We want this to be "character" now, not "numeric" or "integer"

## Next, the dataset has some dates in it that we'll want to use 
## ("Incident.Begin.Date", "incident.End.Date"). Let's see what shape they're
## in and change them to a date if they're not already dates.
class(fema$Incident.Begin.Date) ## if it's not "character", you'd need to 
                                ## change using "as.character" before proceeding

fema$Incident.Begin.Date[1] ## Look at the first observation to see what
                            ## the format looks like (you'll need to tell
                            ## the "as.Date" function what format the date has)

## Mess around with "as.Date" until you're getting what you want:
## (I'm using "head" to look just at the first few results).
## For all the abbreviations for "format", check ?strptime under "Details"
head(as.Date(fema$Incident.Begin.Date, format = "%Y-%m-%d"))
## Once you get this right, transform the dataset.

## If you're changin a few columns in a dataframe at the same time, you can 
## save some time by using "transform" instead of reassigning the columns one at a time like
## fema$Incident.Begin.Date <- as.Date(fema$Incident.Begin.Date, format = "%Y-%m-%d")
fema <- transform(fema,
                  Incident.Begin.Date = as.Date(fema$Incident.Begin.Date,
                                                format = "%Y-%m-%d"),
                  Incident.End.Date = as.Date(fema$Incident.End.Date,
                                                format = "%Y-%m-%d")
                  )

## Now that these are dates, you can do things like get the year for an observation:
head(fema$Incident.Begin.Date)
head(as.POSIXlt(fema$Incident.Begin.Date)$year) ## Add 1900 to get the real year
head(as.POSIXlt(fema$Incident.Begin.Date)$mday) ## Day in the month
head(as.POSIXlt(fema$Incident.Begin.Date)$mon)  ## Month, with January == 0, etc.
head(as.POSIXlt(fema$Incident.Begin.Date)$wday) ## Day of the week, with 0 == Sunday, etc.
## For more things you can pull from date with as.POSIXlt, check ?POSIXlt

## Finally, the "Incident.Type" should be a factor-- there are only a few
## different values this takes, and it categorizes the observation.
class(fema$Incident.Type) ## First, check and see what it is
unique(fema$Incident.Type) ## Check out all the unique values for this column
fema$Incident.Type <- as.factor(fema$Incident.Type) ## we don't need to put in
                                                    ## "levels", because we're not
                                                    ## planning to add any new levels.
table(fema$Incident.Type) ## Now that it's a factor, we can use 'table' to see how
                          ## many declarations there are for each type.

######################################################################
## Use subsetting to get a dataset just with declarations from 2005
## and with "hurricane" incident types. 
######################################################################

## Since we only want to look at 2005, we can now reduce the dataset
## to only include declarations where the incident began in 2005:
fema.2005 <- subset(fema, as.POSIXlt(Incident.Begin.Date)$year == 105)
head(fema.2005, 2)
table(fema.2005$Incident.Type) ## Now see how many different types of declarations
                               ## they had in 2005

## Next, let's limit to just disasters with incident type of "Hurricane"
fema.2005 <- subset(fema.2005, Incident.Type == "Hurricane")
head(fema.2005, 2)
table(fema.2005$Incident.Type) ## Check-- this should be zero now for everything
                               ## but "Hurricane"

## Let's see if we can explore some more. First, check and see how many unique
## "Title"s there are. If it's a reasonable number, we might be able to 
## look through those.
length(unique(fema.2005$Title)) ## Only 9-- that's not too bad. Let's check them out
unique(fema.2005$Title)

## It looks like there are some declarations for Katrina and Rita that 
## have an extra space at the end. Let's get rid of that so all the Hurricane 
## Katrina or Rita titles will be the same. I figured out how to do this 
## by googling "R remove trailing space"
fema.2005$Title <- gsub(" $","", fema.2005$Title, perl=T)
unique(fema.2005$Title) ## Now check it out again

## Now there are some cases where there are several entries for the same 
## storm. For example, there's a "HURRICANE RITA" and a "TROPICAL STORM RITA". 
## Also, there's a "HURRICANE KATRINA" and a "HURRICANE KATRINA EVACUATION".
## Let's add a new column called "storm" that only has the name of the storm.

## I'll write a function that will go through a title and take out the following
## generic words: HURRICANE, TROPICAL STORM, and EVACUATION. There's probably a
## more elegant way to do this in a single line, but this gets the job done.
get.storm <- function(title){
        storm <- gsub("HURRICANE", "", title)
        storm <- gsub("TROPICAL STORM", "", storm)
        storm <- gsub("EVACUATION", "", storm)
        storm <- gsub(" ", "", storm) ## Clean up any extra spaces
        return(storm)
}
## Check out how the new function works on the first Title
fema.2005$Title[1] ## The Title for the first observation
get.storm(fema.2005$Title[1]) ## This seems to be working, so let's add "storm"
fema.2005$storm <- get.storm(fema.2005$Title)
head(fema.2005, 2)

## Finally, "state', "Title" and "storm" might be useful to have as factors instead
## of characters, so let's change them.
fema.2005 <- transform(fema.2005,
                       state = as.factor(state),
                       Title = as.factor(Title),
                       storm = as.factor(storm)
                       )
summary(fema.2005[,c("state", "Title", "storm")]) ## we can use "summary" to check these out

## As a final step, let's remove some of the columns that we aren't interested
## in, so our dataframe will be a little easier to look at.
colnames(fema.2005) ## Let's look at the column names to see what we want to keep
fema.2005 <- subset(fema.2005, select = c("state", "county", "fips",
                                          "Incident.Begin.Date",
                                          "Incident.End.Date", 
                                          "Title", "storm"))
## notice that I reordered the columns by putting the column names in the order 
## I wanted in "select"
head(fema.2005)
