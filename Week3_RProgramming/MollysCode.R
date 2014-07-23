library(foreign)
library(ggplot2)

flood.survey <- read.spss("~/Downloads/flood_survey_sample_20140718.sav",
                to.data.frame = TRUE)
## Warnings are explained at https://stat.ethz.ch/pipermail/r-help/2010-October/257202.html
## and I don't think it looks like they're a problem.

## We can read the labels for each question as well
survey.labels <- attributes(flood.survey)$variable.labels
survey.labels[1:3]
survey.labels

##Let's make sure the "read.spss" brought this in as a dataframe
class(flood.survey)

## Let's check out the data a bit. 
str(flood.survey)
colnames(flood.survey)
summary(flood.survey)

## Identify the column names of the flood-related questions
flood.questions <- colnames(flood.survey)[substring(colnames(flood.survey), 2, 2) == "6"]
head(flood.survey[ , flood.questions])

## Let's check out missing values for the different questions (for
## surveys, this can be a big problem.)
sapply(flood.survey, function(x) { round(100 * sum(is.na(x)) / length(x)) })
max(sapply(flood.survey, function(x) { round(100 * sum(is.na(x)) / length(x)) }))
## At most, a question has 9% missing values (this is question 3).

## Let's also look at the number of unique values each column has and make sure
## that seems reasonable
sapply(flood.survey, function(x) { length(unique(x)) })

## Now let's look at summaries for all of the responses.
summary(flood.survey)
## Check to see if there are any values that seem unusual. For example, why 
## is the max UID so much higher (99996) than other values? Let's check that out
## a bit. 
sort(unique(flood.survey$UID))
length(unique(flood.survey$UID))
## It looks like most values are four digits, but then there are three that are
## 5 digits and start with "9999". What's going on here?

## We can plot the ZIP codes and make sure it looks like they're right.
## For this, I downloaded the ZIP code shape file for Colorado from the 
## US Census' website. There's a good article about using the 'ggmap' package
## at http://stat405.had.co.nz/ggmap.pdf
library(maptools)
library(gpclib)
library(sp)
library(ggmap)
gpclibPermit()

study.zips <- as.character(sort(unique(flood.survey[,"ZIP_SAMPLE"])))
study.zips <- study.zips[!is.na(study.zips)]

shapefile <- readShapeSpatial("~/Downloads/tl_2010_08_zcta510/tl_2010_08_zcta510.shp",
                              proj4string = CRS("+proj=longlat +datum=WGS84"))
study.shapefile <- subset(shapefile, ZCTA5CE10 %in% study.zips)
data <- fortify(study.shapefile, region = "ZCTA5CE10")

qmap('poudre canyon', zoom = 9) +
        geom_polygon(aes(x = long, y = lat, group = group), data = data,
                     colour = 'blue', fill = NA, size = 1.5)

## Now let's check out the data and see if it makes sense-- are relationships
## that we'd expect to be there actually there? One common relationship is that
## income increases with eduction, so let's look at that. 
survey.labels[c("Q73", "household_income_5cat")]
summary(flood.survey[,c(c("Q73", "household_income_5cat"))])
ggplot(flood.survey, aes(x = Q73)) + geom_bar() +
        facet_grid(household_income_5cat ~ .)
ggplot(flood.survey, aes(x = Q73)) + geom_bar() +
        facet_grid(household_income_5cat ~ ., scales = "free_y")
mosaicplot(with(flood.survey, table(household_income_5cat, Q73)))
## A natural split for income seems to be <=400% FPL versus >400% FLP
flood.survey$binary.income <- as.factor(ifelse(
        flood.survey$household_income_5cat == "Household >400% FPL",
        "Household >400% FPL", "Household <=400% FPL"))
flood.survey$binary.income[is.na(flood.survey$household_income_5cat)] <- NA
summary(flood.survey$binary.income)
ggplot(flood.survey, aes(x = Q73)) + geom_bar() +
        facet_grid(binary.income ~ .)

income.educ.tab <- with(flood.survey, table(Q73, binary.income))
income.educ.tab
chisq.test(income.educ.tab)
fisher.test(income.educ.tab)
chisq.test(income.educ.tab, simulate.p.value = TRUE, B = 10000)
chisq.test(income.educ.tab, simulate.p.value = TRUE, B = 10000)$expected
chisq.test(income.educ.tab, simulate.p.value = TRUE, B = 10000)$residuals
## (See http://ww2.coastal.edu/kingw/statistics/R-tutorials/independ.html 
## for more on contingency table analysis in R.)
## This is another case where we may want to find a natural split in the 
## data...
flood.survey$binary.educ <- as.factor(ifelse(flood.survey$Q73 %in% 
                                            c("Less than 9th grade",
                                              "9th to 12th grade, no diploma",
                                              "High school diploma or GED",
                                              "Some college, no degree"),
                                    "No college degree",
                                    "College degree"))
flood.survey$binary.educ[is.na(flood.survey$Q73)] <- NA
summary(flood.survey$binary.educ)
with(flood.survey, table(binary.educ, binary.income))
plot.tab <- with(flood.survey, table(binary.income, binary.educ))
rownames(plot.tab) <- gsub("Household ", "", rownames(plot.tab))
mosaicplot(plot.tab,
           main = "Education versus Income Level",
           ylab = "Education level",
           xlab = "Household income level")
chisq.test(plot.tab)$observed
chisq.test(plot.tab)$expected
chisq.test(plot.tab)$residual
chisq.test(plot.tab)
prop.test(plot.tab)

## Now, let's look a bit at a flood question
survey.labels[flood.questions]
summary(flood.survey[,flood.questions])

## Let's start by looking at inconvenience (Q67D) and stress levels (Q68)
ggplot(flood.survey, aes(x = Q68)) + geom_bar() + ggtitle("Flood-related stress level")
ggplot(flood.survey, aes(x = Q67D)) + geom_bar() + ggtitle("Inconvenience level")
ggplot(flood.survey, aes(x = Q68)) + geom_bar() + 
        ggtitle("Flood-related stress level") + 
        facet_grid(Q67D ~ .)
mosaicplot(flood.survey$Q68 ~ flood.survey$Q67D, 
           main = "Flood stress vs. inconvenience",
           ylab = "Inconvenience", xlab = "Stress")
## Again, we may want to combine some of the data using natural breaks
flood.survey$inconv <- factor(ifelse(flood.survey$Q67D %in% 
                                      c("Moderately", "Very much", "A great deal"),
                              "More than a little", 
                              as.character(flood.survey$Q67D)),
                              levels = c("None at all", "Very little", 
                                         "More than a little"))
summary(flood.survey$inconv)
mosaicplot(flood.survey$Q68 ~ flood.survey$inconv)
table(flood.survey$inconv, flood.survey$Q68)
## You can look at the relationship using ordered logistic regression. There's
## a good tutorial for doing this in R at: http://www.ats.ucla.edu/stat/r/dae/ologit.htm
mod <- polr(Q68 ~ inconv, data = flood.survey, Hess = TRUE)
summary(mod)
ctable <- coef(summary(mod))
## calculate and store p values
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, `p value` = p) ## Add p-values to the table
ctable
ci <- confint(mod) #Get confidence intervals
exp(cbind(OR = coef(mod), ci)) ## Odds ratios and their confidence intervals

## Predict the probabilities of different stress levels by inconvenience level
newdat <- data.frame(inconv = factor(c("None at all", "Very little", "More than a little")))
newdat <- cbind(newdat, predict(mod, newdat, type = "probs"))
newdat

## Now plot those probabilities
library(reshape)
lnewdat <- melt(newdat, id.vars = "inconv")
colnames(lnewdat) <- c("Inconvenience", "Stress", "Probability")
levels(lnewdat$Inconvenience) <- c("More than a little", 
                                   "Very little", 
                                   "None at all")
lnewdat
lnewdat$Stress <- as.numeric(gsub("[^0-9]", "", lnewdat$Stress))
ggplot(lnewdat, aes(x = Stress, y = Probability, colour = Inconvenience)) +
        geom_line(aes(group = Inconvenience))
