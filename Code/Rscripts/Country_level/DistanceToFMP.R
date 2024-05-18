
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script assigns a cell for all FMP points 

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
library(rgeos)
library(ggplot2)

#Change path to data folder

setwd("")

# Read fmp coordinates 

fmp.points <- read.csv('./fmp_geocodes.csv')
fmp <- na.omit(fmp.points)  #Omit missing values

fmp$fmp.id <- 1:nrow(fmp)

# Define coordinates

coordinates(fmp) <- ~fmp_lon+fmp_lat

#Read shape file 

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')
centroids <- gCentroid(shp, byid=TRUE)
distcent <- spDists(centroids, longlat=TRUE) 

plot(shp, border = "grey")
points(centroids, col = "red") 

#Make sure the two files share the same CRS

crs(shp)  
crs(fmp)  
fmp@proj4string <- shp@proj4string
centroids@proj4string <- shp@proj4string

crs(shp)  
crs(fmp) 
crs(centroids) 

plot(shp, border = "grey")
points(fmp, col = "red") 

#Merge fmp datapoints 

out <- over(fmp, shp) 

fmp.data <- as(fmp, "data.frame")

fmp.final <- cbind(fmp.data, out)
write.csv(fmp.final, file = './Rdata/fmp_cell_id.csv')

#Calculate distance 

distcent <- spDists(centroids, fmp, longlat=TRUE) 
shp@data <- cbind(shp@data, distcent)

# Convert full shape file to data frame (SAVE IN R DATA FOLDER)

shp.fmp <- as(shp, "data.frame")

write.csv(shp.fmp, file = './Rdata/fmp_cell_distance.csv')
