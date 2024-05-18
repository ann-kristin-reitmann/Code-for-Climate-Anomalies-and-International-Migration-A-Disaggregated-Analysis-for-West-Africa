
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script matches the FMS towns with the CELL ID of La Ferrara 

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

# Read cell coordinates  

towns <- read.csv('./geo_data_final.csv')

# Define coordinates

coordinates(towns) <- ~longitude+latitude

#Read shape file 

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')

plot(shp, border = "grey")
points(towns, col = "red") 

#Make sure the two files share the same CRS

crs(shp)  
crs(towns)  
towns@proj4string <- shp@proj4string

crs(shp)  
crs(towns) 

#Merge datapoints 

out <- over(towns, shp) 

towns@data <- cbind(towns@data, out)

# Convert full shape file to data frame (SAVE IN R DATA FOLDER)

shp.town <- as(towns, "data.frame")

shp.town <- na.omit(shp.town)
write.csv(shp.town, file = './Rdata/town_cellid.csv')

#Check merge 

# Read cell cordinates  

# Define coordinates

coordinates(shp.town) <- ~longitude_+latitude_m

#Read shape file 

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')

plot(shp, border = "grey")
points(shp.town, col = "red") 
points(towns, col = "blue")
