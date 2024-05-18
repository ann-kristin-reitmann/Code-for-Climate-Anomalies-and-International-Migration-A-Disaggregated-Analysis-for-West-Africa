
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script imports an NC file containing the soil moisture data 
#It then assigns the centroids to a grid shapefile in Africa with a 60 arc-minute resolution

#----------------------------------------------------------------------------------------------------------------------
#Read cell coordinates 
#----------------------------------------------------------------------------------------------------------------------

library(lmomco)
library(ncdf4)
library(sp)
library(raster)
library(rgdal)
library(sf)
library(dplyr)

#Change path to data folder

setwd("")

# Read field capacity and field wilting point 

fieldcap <- raster('./_orig/NASA/fieldcapraster.gri')
extent(fieldcap)
crs(fieldcap)

wiltpoint <- raster('./_orig/NASA/wiltpontraster.gri')
extent(wiltpoint)
crs(wiltpoint)

# Check projection of shapefile 

shp5 <- readOGR('./shapefiles/Africa_Continent/ne_50m_admin_0_countries.shp')

plot(shp5)

#Use shapefile as mask of the raster brick -- extract information for Africa

field.mask <- mask(fieldcap, shp5)
wilt.mask <- mask(wiltpoint, shp5)

#Convert to data frame 

field.df = as.data.frame(field.mask, xy=TRUE)  # Specify the columns to extract from database
wilt.df = as.data.frame(wilt.mask, xy=TRUE)  # Specify the columns to extract from database

field.df = field.df[complete.cases(field.df),]
wilt.df = wilt.df[complete.cases(wilt.df),]

head(field.df)
head(wilt.df)

coordinates(field.df) <- ~x+y
coordinates(wilt.df) <- ~x+y

field.df@proj4string <- shp5@proj4string
wilt.df@proj4string <- shp5@proj4string

#Merge datapoints 

out <- over(shp5, field.df, fn=mean) 
outwilt <- over(shp5, wilt.df, fn=mean) 

shp5@data <- cbind(shp5@data, out)
shp5@data <- cbind(shp5@data, outwilt)

# Convert full shape file to data frame 

shp.field <- as(shp5, "data.frame")

#setwd("./Rdata")

write.csv(shp.field, file = "./Rdata/field_wilt_cells_country.csv")  

library(tmap)

tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("fieldcapraster"), style = "cont", palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))

tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("wiltpontraster"), style = "cont", palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))
