
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
library(raster)
library(rgdal)
library(sf)
library(dplyr)
library(sp)

#Change path to data folder

setwd("")

# Open nc file as raster 

sm.test <- brick('./_orig/ESRL/soilw.mon.mean.v2.nc')

# Check extent of coordinates (should be -180, 180) if 360 check stackflow: https://stackoverflow.com/questions/50204653/how-to-extract-the-data-in-a-netcdf-file-based-on-a-shapefile-in-r

extent(sm.test)

sm.brick = rotate(sm.test)

# Check projection 

extent(sm.brick)
crs(sm.brick)  
crs(sm.test)

# Check projection of shapefile 

shp <-  readOGR('./shapefiles/Africa_Continent/ne_50m_admin_0_countries.shp')

plot(shp)

#Use shapefile as mask of the raster brick -- extract information for Africa

sm.mask <- mask(sm.brick, shp)

#Convert to data frame 

sm.df = as.data.frame(sm.brick, xy=TRUE)  # Specify the columns to extract from database

sm.df = sm.df[complete.cases(sm.df),]
head(sm.df)

coordinates(sm.df) <- ~x+y

sm.df@proj4string <- shp@proj4string

#Merge datapoints 

out <- over(shp, sm.df, fn=mean) 

shp@data <- cbind(shp@data, out)

# Convert full shape file to data frame

shp.df <- as(shp, "data.frame")

#setwd("./Rdata")

write.csv(shp.df, file = "./Rdata/moisture_cells_country.csv")  

# The file above is read and prepared in stata 

# Check projection of shapefile

shp <-   readOGR('./shapefiles/Africa_Continent/ne_50m_admin_0_countries.shp')

moisture <- read.csv('./Rdata/moisture_cells_year_country.csv')

shp@data <- cbind(shp@data, moisture)

nummig<- read.csv("./Rdata/.5x.5/num_mig_desc_country.csv")

shp@data <- cbind(shp@data, nummig)

# Check projection of shapefile 

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

moisture5 <- read.csv('./Rdata/.5x.5/moisture_cells_year.csv')

shp5@data <- cbind(shp5@data, moisture5)

nummig5<- read.csv("./Rdata/.5x.5/num_mig_desc.csv")

shp5@data <- cbind(shp5@data, nummig5)
