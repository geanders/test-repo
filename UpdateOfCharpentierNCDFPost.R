# Based on http://www.r-bloggers.com/on-ncdf-climate-datasets/
# Updated to use ncdf4
# Links worked as of Jan. 2016

library(ncdf4)
library(lubridate)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)

# Example from http://dods.ipsl.jussieu.fr/mc2ipsl/
download.file("http://dods.ipsl.jussieu.fr/mc2ipsl/CMIP5/output1/IPSL/IPSL-CM5A-MR/historicalNat/day/atmos/day/r1i1p1/latest/tas/tas_day_IPSL-CM5A-MR_historicalNat_r1i1p1_20000101-20121231.nc",
              destfile="temp.nc")
nc <- nc_open("temp.nc")
lon <- ncvar_get(nc,"lon")
nlon <- dim(lon)
lat <- ncvar_get(nc,"lat")
nlat <- dim(lat)
time <- ncvar_get(nc,"time")
tunits <- ncatt_get(nc, "time", "units")
orig <- as.Date(ymd_hms(str_replace(
        tunits$value, "days since ", "")))
dates <- orig + time
ntime <- length(dates)

# Creates a 3-D array with temperature by time and grid location
tab_val <- ncvar_get(nc, varid = "tas",  ## "tas" is temperature variable
                     start = c(1, 1, 1))

fill_value <- ncatt_get(nc, varid = "tas",
                        attname = "_FillValue")  ## Specify which attribute to read
tab_val[tab_val == fill_value$value] <- NA

# Convert from array to dataframe
tab_val_vect <- as.vector(tab_val) ## Unwrap array
tab_val_mat <- matrix(tab_val_vect,
                      nrow = nlon * nlat,  ## Row = long-lat combo
                      ncol = ntime)  ## Column = time point
lon_lat <- expand.grid(lon, lat)
lon_lat <- lon_lat %>% mutate(Var1 = as.vector(Var1),
                              Var2 = as.vector(Var2))

res <- data.frame(cbind(lon_lat, tab_val_mat))

# Clean up column names
noms <- str_c(year(dates),
              month.abb[month(dates)] %>%
                      tolower, sprintf("%02s", day(dates)),
              sep = "_")
names(res) <- c("lon", "lat", noms)

res <- res %>%
        mutate(lon = ifelse(lon >= 180,  ## Adjust for problems with lon conventions
                            yes = lon - 360,
                            no = lon)) %>%
        filter(lon < 40, lon > -20,  ## Pull just for Europe
               lat < 75, lat > 30) %>%
        gather(key, value, -lon, -lat) %>%
        separate(key, into = c("year", "month", "day"), sep="_")

# Get monthly summaries for 1986 to 2005
temp_moy_hist <- res %>%
        filter(year >= 1986, year <= 2005) %>%
        group_by(lon, lat, month) %>%
        summarise(temp = mean(value, na.rm = TRUE)) %>%
        ungroup %>%
        mutate(month = factor(month, levels = c("jan", "feb", "mar",
                                                "apr", "may", "jun",
                                                "jul", "aug", "sep",
                                                "oct", "nov", "dec")))

# Plot monthly summaries by month
ggplot(data = temp_moy_hist,
       aes(x = lon, y = lat, fill = temp)) +
        geom_raster() + coord_quickmap() +
        facet_wrap(~month)

download.file(
        "http://freakonometrics.free.fr/carte_europe_df.rda",
        destfile = "carte_europe_df.rda")
load("carte_europe_df.rda")

# Plot monthly summaries by month with country boundaries
ggplot(data = temp_moy_hist,
       aes(x = lon, y = lat, fill = temp)) +
        geom_raster() +
        scale_fill_gradientn(colours = c("#0000FFFF",
                                         "#FFFFFFFF",
                                         "#FF0000FF")) +
        coord_quickmap(xlim = c(-20, 40),
                       ylim = c(30, 75)) +
        facet_wrap(~month) +
        geom_polygon(data = carte_europe_df,
                     aes(x=long, y=lat, group=group), fill = NA,
                     color = "black", size = 0.2, alpha = 0.5)
