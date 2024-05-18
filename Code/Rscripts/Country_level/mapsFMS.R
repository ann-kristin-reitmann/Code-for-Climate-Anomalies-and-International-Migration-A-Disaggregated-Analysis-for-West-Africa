
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script imports an NC file containing the SPEI03 data 
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

#Change path to data folder

setwd("")

# Check projection of shapefile 

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')
migdata <- read.csv('./month_data_maps.csv')

# the migdata is generated from the final cell data in STATA 

plot(shp)

m <- merge(shp, migdata, by='CELLID')
