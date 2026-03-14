
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

setwd(".../data/")

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

#Generate centroids

#shp5_cent <-  gCentroid(shp5, byid = TRUE)

plot(shp5)
points(shp5_cent, col = "red") 

#Convert full shape file to data frame 

shp.df <- as(shp5, "data.frame")

#setwd("./Rdata")

write.csv(shp.df, file = "./Rdata/.5x.5/raster_Africa.csv")
