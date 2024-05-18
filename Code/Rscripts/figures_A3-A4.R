
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script produces figures A3 and A4

#----------------------------------------------------------------------------------------------------------------------
#Generate Maps
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

#Check projection of shapefile 

shp <-   readOGR('./data/shapefiles/Africa_Continent/ne_50m_admin_0_countries.shp')

moisture <- read.csv('./data/Rdata/moisture_cells_year_country.csv')

shp@data <- cbind(shp@data, moisture)

nummig<- read.csv("./data/Rdata/.5x.5/num_mig_desc_country.csv")

shp@data <- cbind(shp@data, nummig)

#Read shape file 

shp5 <- readOGR('./data/shapefiles/Africa5x5/Africa5x5grid.shp')

moisture5 <- read.csv('./data/Rdata/.5x.5/moisture_cells_year.csv')

shp5@data <- cbind(shp5@data, moisture5)

nummig5<- read.csv("./data/Rdata/.5x.5/num_mig_desc.csv")

shp5@data <- cbind(shp5@data, nummig5)

library(tmap)

#Figure A3

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
tmap_save(combined, "./output/figures/figure_A3.pdf") 

#Figure A4

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
tmap_save(comb, "./output/figures/figure_A4.pdf") 

