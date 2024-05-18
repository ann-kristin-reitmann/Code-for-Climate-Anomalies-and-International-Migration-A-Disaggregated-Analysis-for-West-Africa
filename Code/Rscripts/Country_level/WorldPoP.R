
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script imports a CSV file containing the centroids of the 30 arc-minute grids on MICRA crop calendars
#It then assigns the centroids to a grid shapefile in Africa with a 60 arc-minute resolution

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

pop <- raster('./_orig/worldpop/ppp_2018_1km_Aggregated.tif')

shp$pop_sum <- extract(pop, shp, fun=function(x,...) sum(x, na.rm=T))

#velox(pop)$extract(sp=shp, fun=sum)

# Convert full shape file to data frame 

shp.df <- as(shp, "data.frame")

write.csv(shp.df, file = "./Rdata/pop18_cells.csv")

# Maps: last month of every quarter 

tm_shape(shp)+ 
  tm_polygons(c("pop_sum"), style = "cont", palette="RdYlBu")

#velox(pop)$extract(sp=shp, fun=function(x,...) sum(x, na.rm=T))
