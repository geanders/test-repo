## Example code used in in-person meeting at CSU for Data Scientists Toolbox.
## Code adapted in part or full from Jean-Robert's blog: ean-robert.github.io
arret_ligne <- read.csv("http://data.ratp.fr/?eID=ics_od_datastoredownload&file=60", 
                        header=F, sep="#",
                        col.names=c("ID","Ligne","Type"),
                        stringsAsFactors=F)
arret_ligne <- subset(arret_ligne, Type == "metro")

arret_positions <- read.csv("http://data.ratp.fr/?eID=ics_od_datastoredownload&file=64", 
                            header=F, sep="#",
                            col.names=c("ID","X","Y","Nom","Ville","Type"),
                            stringsAsFactors=F)
arret_positions <- subset(arret_positions, Type == "metro")

ggplot(arret_positions, aes(x = X, y = Y)) + geom_point()