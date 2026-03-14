
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

#Check projection of shapefile 

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')
migdata <- read.csv('./month_data_maps.csv')

#The migdata is generated from the final cell data in STATA 

plot(shp)

m <- merge(shp, migdata, by='CELLID')

#----------------------------------------------------------------------------------------------------------------------------------
# Produce maps 
#----------------------------------------------------------------------------------------------------------------------------------

library(tmap)

setwd(" ")

#Maps per year
tm_shape(m,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("ymigrant2018", "ymigrant2019"), breaks = c(0, 0.1, 1, 10, 50, 500, 4000) , title = c("2018", "2019"),  palette="Blues") +
  tm_layout(legend.position = c("left", "bottom"))

#Maps per month 
tm_shape(m,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("shmigrant2018", "shmigrant2019"), style = 'cont', title = c("2018", "2019"),  palette="Blues") +
  tm_layout(legend.position = c("left", "bottom"))

#Maps per month 
tm_shape(m,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("migperthousand2018", "migperthousand2019"), breaks = c(0, 0.005, .03, .16, .45, 3, 16),  title = c("2018", "2019"),  palette="Blues") +
  tm_layout(legend.position = c("left", "bottom"))

#Average SPEI 2016, 2017, 2018
tm_shape(m,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("spei2016", "spei2017", "spei2018"), style = 'cont' , title = c("2016", "2017", "2018"),  palette="RdYlGn", midpoint=0) +
  tm_layout(legend.position = c("left", "bottom"))

#Average SPEI growing season 2016, 2017, 2018
tm_shape(m,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("speig2016", "speig2017", "speig2018"), style = 'cont' , title = c("2016", "2017", "2018"),  palette="RdYlGn", midpoint=0) +
  tm_layout(legend.position = c("left", "bottom"))
