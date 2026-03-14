
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

setwd(".../data/")

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

pop <- raster('./_orig/worldpop/ppp_2018_1km_Aggregated.tif')

shp5$pop_sum <- extract(pop, shp5, fun=function(x,...) sum(x, na.rm=T))

#Convert full shape file to data frame 

shp.df <- as(shp5, "data.frame")

write.csv(shp.df, file = "./Rdata/.5x.5/pop18_cells.csv")

#Maps: last month of every quarter 

tm_shape(shp5)+ 
  tm_polygons("pop_sum", style = "log10", palette="Blues", n = 10)

#velox(pop)$extract(sp=shp, fun=function(x,...) sum(x, na.rm=T))
