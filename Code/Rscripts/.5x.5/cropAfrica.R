
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

#Change path to data folder

setwd(".../data/")

#Read cell coordinates  

crops <- read.csv('./QGIS/cell_crops_coord.csv')

#Define coordinates

coordinates(crops) <- ~lon+lat

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

plot(shp5, border = "grey")
points(crops, col = "red") 

#Make sure the two files share the same CRS

crs(shp5)  
crs(crops)  
crops@proj4string <- shp5@proj4string

#Merge datapoints 

out <- over(shp5, crops) 

shp5@data <- cbind(shp5@data, out)

#Convert full shape file to data frame (SAVE IN R DATA FOLDER)

shp.crop <- as(shp5, "data.frame")

write.csv(shp.crop, file = './Rdata/.5x.5/crop_cellid.csv')
