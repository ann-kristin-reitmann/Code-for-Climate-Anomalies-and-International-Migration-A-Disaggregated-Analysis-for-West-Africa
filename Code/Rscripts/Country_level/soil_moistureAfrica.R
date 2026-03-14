
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

setwd(".../data/")

#Open nc file as raster 

sm.test <- brick('./_orig/ESRL/soilw.mon.mean.v2.nc')

#Check extent of coordinates (should be -180, 180) if 360 check stackflow: https://stackoverflow.com/questions/50204653/how-to-extract-the-data-in-a-netcdf-file-based-on-a-shapefile-in-r

extent(sm.test)

sm.brick = rotate(sm.test)

#Check projection 

extent(sm.brick)
crs(sm.brick)  
crs(sm.test)

#Check projection of shapefile 

shp <-  readOGR('./shapefiles/Africa_Continent/ne_50m_admin_0_countries.shp')

plot(shp)

#Use shapefile as mask of the raster brick -- extract information for Africa

sm.mask <- mask(sm.brick, shp)

#Convert to data frame 

sm.df = as.data.frame(sm.brick, xy=TRUE)  #Specify the columns to extract from database

sm.df = sm.df[complete.cases(sm.df),]
head(sm.df)

coordinates(sm.df) <- ~x+y

sm.df@proj4string <- shp@proj4string

#Merge datapoints 

out <- over(shp, sm.df, fn=mean) 

shp@data <- cbind(shp@data, out)

#Convert full shape file to data frame

shp.df <- as(shp, "data.frame")

#setwd("./Rdata")

write.csv(shp.df, file = "./Rdata/moisture_cells_country.csv")  

#The file above is read and prepared in stata 

#Check projection of shapefile

shp <-   readOGR('./shapefiles/Africa_Continent/ne_50m_admin_0_countries.shp')

moisture <- read.csv('./Rdata/moisture_cells_year_country.csv')

shp@data <- cbind(shp@data, moisture)

nummig<- read.csv("./Rdata/.5x.5/num_mig_desc_country.csv")

shp@data <- cbind(shp@data, nummig)

#Check projection of shapefile 

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

moisture5 <- read.csv('./Rdata/.5x.5/moisture_cells_year.csv')

shp5@data <- cbind(shp5@data, moisture5)

nummig5<- read.csv("./Rdata/.5x.5/num_mig_desc.csv")

shp5@data <- cbind(shp5@data, nummig5)

#----------------------------------------------------------------------------------------------------------------------------------
# Produce maps 
#----------------------------------------------------------------------------------------------------------------------------------

library(tmap)

setwd(".../doc/")

#Maps per year

tm_shape(shp, xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("lrsma32018", "lrsma82018", "lrsma32019", "lrsma82019"), 
              title = c("SMA 03-2018", "SMA 08-2018", "SMA 03-2019", "SMA 08-2019"), 
              style = "cont", n=6, midpoint=0) +
  tm_layout(legend.position = c("left", "bottom")) 

gridex <- tm_shape(shp5, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("lrsma32018", "lrsma82018", "lrsma2018", "lrsma32019", "lrsma82019"), 
              title = c("SMA index", "SMA index", "SMA index", "SMA index"), 
              style = "cont", n=6, midpoint=0, breaks = c(-2,-1,0,1,2)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("Average SMA in March 2018", "Average SMA in August 2018", "Average SMA in March 2019", "Average SMA in August 2019")) 
tmap_save(gridex, "./lrsma_grid.pdf")  

countryex <-  tm_shape(shp, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("lrsma32018", "lrsma82018", "lrsma32019", "lrsma82019"), 
              title = c(" ", " ", " ", " "), 
              style = "cont", n=6, midpoint=0, breaks = c(-2,-1,0,1,2)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("Average SMA in March 2018", "Average SMA in August 2018", "Average SMA in March 2019", "Average SMA in August 2019")) 
tmap_save(countryex, "./lrsma_country.pdf")  

test <-  tm_shape(shp5, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("lrsma2018m3", "lrsma2018m8", "lrsma2018"), 
              title = c(" ", " "), 
              style = "cont", n=6, midpoint=0, breaks = c(-2,-1,0,1,2)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("A. SMA in March 2018", "B. SMA in August 2018", "C. Average SMA in 2018")) 

test2 <-  tm_shape(shp, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("lrsma2018m3", "lrsma2018m8", "lrsma2018"), 
              title = c(" ", " "), 
              style = "cont", n=6, midpoint=0, breaks = c(-2,-1,0,1,2)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("D. SMA in March 2018", "E. SMA in August 2018", "F. Average SMA in 2018")) 

combined <- tmap_arrange(test, test2, nrow = 2)
tmap_save(combined, "./lrsma_country_grid.pdf") 

tm_shape(shp5, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("cmigrant3", "cmigrant8", "totmigrant"), 
              title = c(" ", " "), palette="Blues",
              style = "cont", n=6, breaks = c(0,5,10,20,40,60,200,500,1000,4000)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("A. No. Migrants March 2018", "B. Num. Migrants August 2018", "C. Total Migrants in 2018")) 

tm_shape(shp, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("cmigrant3", "cmigrant8", "totmigrant"), 
              title = c(" ", " "), palette="Blues",
              style = "cont", n=6) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("D. No. Migrants March 2018", "E. Num. Migrants August 2018", "F. Total Migrants in 2018")) 

test1 <- tm_shape(shp5, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("cmigrant3"), 
              title = c(" ", " "), palette="Blues",
              style = "cont", n=6, breaks = c(0,1,10,50,100,300)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("A. No. Migrants March 2018")) 

test2 <- tm_shape(shp5, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("cmigrant8"), 
              title = c(" ", " "), palette="Blues",
              style = "cont", n=6, breaks = c(0,1,10,50,100,300)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("B. No. Migrants August 2018")) 

test3 <- tm_shape(shp5, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("totmigrant"), 
              title = c(" ", " "), palette="Blues",
              style = "cont", n=6, breaks = c(0,10,100,500,1000,3000)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("C. Total Migrants in 2018")) 

cty1 <- tm_shape(shp, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("cmigrant3"), 
              title = c(" ", " "), palette="Blues",
              style = "cont", n=6, breaks = c(0,10,50,100,200,300)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("A. No. Migrants March 2018")) 

cty2 <- tm_shape(shp, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("cmigrant8"), 
              title = c(" ", " "), palette="Blues",
              style = "cont", n=6, breaks = c(0,10,50,100,200,300))  +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("B. No. Migrants August 2018")) 

cty3 <- tm_shape(shp, xlim=c(-5, 20),  ylim=c(-5, 20)) + 
  tm_polygons(c("totmigrant"), 
              title = c(" ", " "), palette="Blues",
              style = "cont", n=6, breaks = c(0,100,500,1000,2000,3000))  +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("C. Total Migrants in 2018")) 

comb <- tmap_arrange(test1, test2, test3, cty1, cty2, cty3, nrow = 2)
tmap_save(comb, "./mig_country_grid.pdf") 
