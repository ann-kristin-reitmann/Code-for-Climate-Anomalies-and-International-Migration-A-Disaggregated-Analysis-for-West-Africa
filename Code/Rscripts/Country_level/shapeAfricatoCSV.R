
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script converts the shapefile into a data frame 

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

#Change path to data folder

setwd("")

# Check projection of shapefile 

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')

plot(shp)

# Convert full shape file to data frame 

shp.df <- as(shp, "data.frame")

#setwd("./Rdata")

write.csv(shp.df, file = "./Rdata/raster_Africa.csv")
