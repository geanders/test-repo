## Example code used in in-person meeting at CSU for Data Scientists Toolbox.
## Code adapted in part or full from TRinker's R blog: http://trinkerrstuff.wordpress.com/2014/02/09/sochi-olympic-medals-2/

packs <- c("knitr", "ggplot2", "XML", "reshape2", "rCharts")
lapply(packs, require, character.only = TRUE)

theurl = "http://www.sochi2014.com/en/medal-standings" 
include.zero = FALSE
                                
## Grab Data, Clean and Reshape
raw <- readHTMLTable(theurl, header=FALSE, 
                     colClasses = c(rep("factor", 2), rep("numeric", 4)))
raw <- as.data.frame(raw)[, -1]
colnames(raw) <- c("Country", "Gold", "Silver", "Bronze", "Total")
raw <- with(raw, raw[order(Total, Gold, Silver, Bronze), ])
if (!include.zero) {
        raw <- raw[raw[, "Total"] != 0, ]
}
raw[, "Country"] <- factor(raw[, "Country"], levels = raw[, "Country"])
rownames(raw) <- NULL
mdat <- melt(raw, id = "Country")
colnames(mdat)[2:3] <- c("Place", "Count")
mdat[, "Place"] <- factor(mdat[, "Place"], levels=c("Gold", "Silver", "Bronze", "Total"))  
## Plot the Data
plot1 <- ggplot(mdat, aes(x = Count, y = Country, colour = Place)) +
        geom_point() +
        facet_grid(.~Place) + theme_bw()+
        scale_colour_manual(values=c("#CC6600", "#999999", "#FFCC33", "#000000")) 
print(plot1)
                
