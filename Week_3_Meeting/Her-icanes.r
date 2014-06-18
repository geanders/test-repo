setwd("/Users/brookeanderson/Downloads")
#install.packages("xlsx")
library(xlsx)

## Read in the data (saved to my Downloads folder)
## data source: http://www.pnas.org/content/suppl/2014/05/30/1402786111.DCSupplemental/pnas.1402786111.sd01.xlsx
hurr.data <- read.xlsx("pnas.1402786111.sd01.xlsx", 
                       sheetName = "Archival Study", 
                       endRow = 93)
hurr.data$gender <- as.factor(ifelse(hurr.data$Gender_MF == 1, 
                           "Her-icanes", "Him-icanes"))

## Plot mean deaths by storm name
#install.packages("plyr")
library(plyr)
df <- ddply(hurr.data, .(gender), summarise,
            mean_deaths = mean(alldeaths))
#install.packages("ggplot2")
library(ggplot2)
## Plot 'boring' scenario
ggplot(df, aes(x = gender, y = rep(mean(mean_deaths), 2))) + geom_point() +
        xlab("") + ylab("Mean of storm deaths") + 
        ylim(c(14, 24))
## Plot our data
ggplot(df, aes(x = gender, y = mean_deaths)) + geom_point() + 
        xlab("") + ylab("Mean of storm deaths") + 
        ylim(c(14, 24))

## Plot out data more fully
df <- ddply(hurr.data, .(gender), summarise,
            mean.deaths = mean(alldeaths))
ggplot(hurr.data, aes(x = gender, y = alldeaths)) + 
        geom_point(alpha = 0.2, size = 4,
                   position=position_jitter(width=0.25,height=0)) + 
        xlab("") + ylab("Deaths from storm") + 
        geom_errorbar(data = df, 
                      aes(y = mean.deaths, ymax = mean.deaths,
                          ymin = mean.deaths))

## Determine number of storms by gender
table(hurr.data$gender)

## Plot number of storms by time
df.1 <- ddply(hurr.data, .(Year), summarise,
            num.hurr = sum(Gender_MF),
            gender = "Her-icanes")
df.2 <- ddply(hurr.data, .(Year), summarise,
              num.hurr = length(Gender_MF) - sum(Gender_MF),
              gender = "Him-icanes")
df <- rbind(df.1, df.2)
ggplot(df, aes(x = Year, y = num.hurr)) + 
        geom_bar(aes(group = gender, fill = gender), stat = "identity") +
        facet_grid(gender ~ .) + 
        ylab("Number of storms")

## Plot storm deaths by time
hurr.data$pre1979 <- ifelse(hurr.data$Year < 1979,
                            "Yes", "No")
df <- ddply(hurr.data, .(pre1979), summarise,
            mean.deaths = mean(alldeaths))
ggplot(hurr.data, aes(x = Year, y = alldeaths)) + 
        geom_point(size = 3, alpha = 0.5, 
                   position = position_jitter(width = 0.3, height = 0)) + 
        ylab("Deaths from storm")
ggplot(hurr.data, aes(x = Year, y = alldeaths)) + 
        geom_point(aes(colour = gender), size = 3, alpha = 0.5, 
                   position = position_jitter(width = 0.3, height = 0)) + 
        geom_vline(aes(xintercept = 1978.5), linetype = "dashed") + 
        ylab("Deaths from storm") + 
        geom_line(aes(x = c(1950, 1978),
                      y = rep(df$mean.deaths[df$pre1979 == "Yes"] , 2))) + 
        geom_line(aes(x = c(1979, 2012),
                      y = rep(df$mean.deaths[df$pre1979 == "No"] , 2)))

## Limit data to 1979 or later
new.df <- subset(hurr.data, pre1979 == "No")
df <- ddply(new.df, .(gender), summarise,
            mean.deaths = mean(alldeaths))
## Plot new 'boring' scenario
ggplot(df, aes(x = gender, y = rep(mean(mean.deaths), 2))) + geom_point() +
        xlab("") + ylab("Mean of storm deaths") + 
        ylim(c(0, 160))
## Plot new data
ggplot(new.df, aes(x = gender, y = alldeaths)) + 
        geom_point(alpha = 0.2, size = 3,
                   position=position_jitter(width=0.2,height=0)) + 
        xlab("") + ylab("Deaths from storm") + 
        geom_errorbar(data = df, 
                      aes(y = mean.deaths, ymax = mean.deaths,
                          ymin = mean.deaths)) +
        ylim(c(0, 160))

## Plot normal distribution for mean and sd of hurricane deaths 
## (post 1979), *if* they were normally distributed (they're not)
y <- data.frame( y = rnorm(length(new.df$alldeaths),
                           mean = mean(new.df$alldeaths),
           sd = sd(new.df$alldeaths)))
ggplot(y, aes(x = y)) + geom_histogram(colour = "white") + 
        xlab("Number of deaths in the storm") + 
        ylab("Number of storms") + 
        xlim(c(-80, 170)) + ylim(c(0, 35))

ggplot(new.df, aes(x = alldeaths)) + geom_histogram(colour = "white") +
        xlim(c(-80, 170)) +  ylim(0, 35) + 
        xlab("Number of deaths in the storm") + 
        ylab("Number of storms")

## Plot hurricanes by rank of deaths
oo <- order(new.df$alldeaths, decreasing = TRUE)
new.df <- new.df[oo,]
new.df$rank <- 1:nrow(new.df)
head(new.df[,c("Year", "Name", "alldeaths", "rank")])
ggplot(new.df, aes(x = gender, y = rank)) + geom_point() + 
        ylab("Rank of storm for number of storm deaths") + 
        scale_y_reverse()

## Plot several random versions of gender and rank
## (repeat this for different simulations)
ggplot(new.df, aes(x = gender,
                   y = sample(new.df$rank, size = nrow(new.df)))) + 
        geom_point() + 
        ylab("Rank of storm") + 
        scale_y_reverse()


## Perform rank test
#install.packages("coin")
library(coin)
wilcox_test(alldeaths ~ gender, data = new.df, conf.int = TRUE)