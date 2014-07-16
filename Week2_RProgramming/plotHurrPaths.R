library(maptools)
library(maps)
library(sp)
library(rgeos)

create.SpatialLines <- function(hurr.paths, ID = "a"){
  c1 <- cbind(
              as.numeric(hurr.paths$longitude),
              as.numeric(hurr.paths$latitude))
  L1 <- Line(c1)
  Ls1 <- Lines(list(L1), ID = ID)
  SL1 <- SpatialLines(list(Ls1))
  return(SL1)
}

hurr.lines <- lapply(hurr.paths, create.SpatialLines)

## Plot base US state map

oldpar <- par(oma = rep(0, 4), mar = rep(0, 4))
map("state", 
    region = c('maine', 'new hampshire', 'vermont',
               'massachusetts', 'connecticut',
               'new york', 'rhode island',
               'new jersey', 'delaware',
               'pennsylvania', 'maryland',
               'virginia', 'north carolina',
               'south carolina', 'georgia',
               'florida', 'alabama', 'mississippi',
               'louisiana', 'texas',
               'west virginia', 'arkansas',
               'tennessee', 'kentucky', 'oklahoma',
               'missouri', 'illinois', 'kentucky',
               'indiana', 'michigan', 'ohio',
               'wisconsin', 'kansas', 'iowa'),
    interior = FALSE)
map("state", 
    region = c('maine', 'new hampshire', 'vermont',
               'massachusetts', 'connecticut',
               'new york', 'rhode island',
               'new jersey', 'delaware',
               'pennsylvania', 'maryland',
               'virginia', 'north carolina',
               'south carolina', 'georgia',
               'florida', 'alabama', 'mississippi',
               'louisiana', 'texas',
               'west virginia', 'arkansas',
               'tennessee', 'kentucky', 'oklahoma',
               'missouri', 'illinois', 'kentucky',
               'indiana', 'michigan', 'ohio',
               'wisconsin', 'kansas', 'iowa'),
    boundary = FALSE, 
    col = "gray", 
    add = TRUE)


## Plot storms

## Plot one storm
plot(hurr.lines[["Katrina"]], add = TRUE, col = "cyan", lty = 1)

## Plot all the storms
storm.lines <- lapply(hurr.lines, plot, add = TRUE,
                    col = "lightblue", lwd = 2)

