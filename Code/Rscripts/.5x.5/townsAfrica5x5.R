
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

setwd(".../data/")

#Read cell coordinates  

towns <- read.csv('./geo_data_final.csv')

#Define coordinates

coordinates(towns) <- ~longitude+latitude

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

plot(shp5, border = "grey")
points(towns, col = "red") 

#Make sure the two files share the same CRS

crs(shp5)  
crs(towns)  
towns@proj4string <- shp5@proj4string

crs(shp5)  
crs(towns) 

#Merge datapoints 

out <- over(towns, shp5) 

towns@data <- cbind(towns@data, out)

#Convert full shape file to data frame (SAVE IN R DATA FOLDER)

shp.town5 <- as(towns, "data.frame")

shp.town5 <- na.omit(shp.town5)

write.csv(shp.town5, file = './Rdata/.5x.5/town_cellid.csv')

#Check merge 

#Read cell coordinates  

#Define coordinates

coordinates(shp.town5) <- ~longitude+latitude

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

plot(shp5, border = "grey")
points(towns, col = "purple") 
points(shp.town5, col = "red") 
