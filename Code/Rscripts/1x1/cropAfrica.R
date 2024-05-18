
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

setwd("")

# Read cell cordinates  

crops <- read.csv('./QGIS/cell_crops_coord.csv')

# Define coordinates

coordinates(crops) <- ~lon+lat

#Read shape file 

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')

plot(shp, border = "grey")
points(crops, col = "red") 

#Make sure the two files share the same CRS

crs(shp)  
crs(crops)  
crops@proj4string <- shp@proj4string

crs(shp)  
crs(crops) 

#Merge datapoints 

out <- over(shp, spei.df, fn=mean) 

shp@data <- cbind(shp@data, out)

#Merge datapoints 
out <- over(shp, crops) 

shp@data <- cbind(shp@data, out)


# Convert full shape file to data frame (SAVE IN R DATA FOLDER)

shp.crop <- as(shp, "data.frame")

write.csv(shp.crop, file = './Rdata/crop_cellid.csv')
