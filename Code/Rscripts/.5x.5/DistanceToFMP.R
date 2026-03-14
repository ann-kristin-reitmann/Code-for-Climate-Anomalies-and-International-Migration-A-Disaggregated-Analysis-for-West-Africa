
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

setwd(".../data/")

#Read fmp coordinates 

fmp.points <- read.csv('./fmp_geocodes.csv')
fmp <- na.omit(fmp.points)  #Omit missing values

fmp$fmp.id <- 1:nrow(fmp)

#Define coordinates

coordinates(fmp) <- ~fmp_lon+fmp_lat

memory.size(max = TRUE)

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')
centroids <- gCentroid(shp5, byid=TRUE)

plot(shp5, border = "grey")
points(centroids, col = "red") 

#Make sure the two files share the same CRS

crs(shp5)  
crs(fmp)  
fmp@proj4string <- shp5@proj4string
centroids@proj4string <- shp5@proj4string

crs(shp5)  
crs(fmp) 
crs(centroids) 

plot(shp5, border = "grey")
points(fmp, col = "red") 

#Merge fmp datapoints 

out <- over(fmp, shp5) 

fmp.data <- as(fmp, "data.frame")

fmp.final <- cbind(fmp.data, out)
write.csv(fmp.final, file = './Rdata/.5x.5/fmp_cell_id.csv')

#Calculate distance 

distcent <- spDists(centroids, fmp, longlat=TRUE) 
shp5@data <- cbind(shp5@data, distcent)

#Convert full shape file to data frame (SAVE IN R DATA FOLDER)

shp.fmp <- as(shp5, "data.frame")

write.csv(shp.fmp, file = './Rdata/.5x.5/fmp_cell_distance.csv')
