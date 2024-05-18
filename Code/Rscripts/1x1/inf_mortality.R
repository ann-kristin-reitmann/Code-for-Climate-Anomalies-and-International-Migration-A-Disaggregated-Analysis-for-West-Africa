
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script imports a CSV file containing the centroids of the 30 arc-minute grids on infant mortality

#----------------------------------------------------------------------------------------------------------------------
#Read cell coordinates 
#----------------------------------------------------------------------------------------------------------------------

library(lmomco)
library(ncdf4)
library(raster)
library(rgdal)
library(sf)
library(dplyr)
library(spData)
library(sp)
library(velox)
library(tmap)

#Change path to data folder

setwd("")

#Read shape file 

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')
 
shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

inf <- raster('./_orig/Columbia/infant_mortality_rates_v2.tif')
crs(shp)
crs(inf)

values(inf)[values(inf) < 0] = NA
plot(inf) 

shp$inf_mort <- extract(inf, shp, fun=function(x,...) mean(x, na.rm=T))

shp5$inf_mort <- extract(inf, shp5, fun=function(x,...) mean(x, na.rm=T))

# Convert full shape file to data frame 

shp.df <- as(shp, "data.frame")
shp5.df <- as(shp5, "data.frame")

write.csv(shp.df, file = "./Rdata/infmort_cells.csv")
write.csv(shp5.df, file = "./Rdata/.5x.5/infmort_cells.csv")

library(tmap)

# Maps: last month of every quarter 

tm_shape(shp5)+ 
  tm_polygons(c("inf_mort"),  breaks = c(0, 1, 10, 50, 200, 500))
