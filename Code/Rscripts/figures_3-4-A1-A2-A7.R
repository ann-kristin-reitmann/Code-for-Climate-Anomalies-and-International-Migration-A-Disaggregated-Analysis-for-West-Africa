
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script produces figures 3, 4, A1, A2, A7

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

#Read shape file 

shp5 <- readOGR('./data/shapefiles/Africa5x5/Africa5x5grid.shp')

moisture <- read.csv('./data/Rdata/.5x.5/moisture_cells_year.csv')

shp5@data <- cbind(shp5@data, moisture)

shp.fmp <- as(shp5, "data.frame")

mig <- read.csv('./data/Rdata/.5x.5/final_sma_mig.csv')

shp5@data <- cbind(shp5@data, mig)

library(tmap)

#Figure 3: 

intmig <- tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("yinternational2018", "yinternational2019"), 
              title = c("Total migration 2018", "Total migration 2019"), 
              breaks = c(0, 1, 4, 10, 20, 100, 4000), labels = c("[0 to 1)", "[1 to 4)", "[4 to 10)", "[10 to 20)", "[20 to 100)", "[>100]"), interval.closure="left", palette="Greens") +
  tm_layout(legend.position = c("left", "bottom"))
tmap_save(intmig, "./output/figures/figure_3.pdf")  

#Figure 4: 

sma <- tm_shape(shp5, xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("ylrsma2018", "ylrsma2019", "ylrsma_gs2018", "ylrsma_gs2019"), 
              title = c("SMA index", "SMA index", "SMA index", "SMA index"), 
              style = "cont", n=6, midpoint=0, breaks = c(-2,-1,0,1,2)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("A. Average SMA in 2018", "B. Average SMA in 2019", "C. Average SMA in 2018: Growing Season Months", "D. Average SMA in 2019: Growing Season Months"))  
tmap_save(sma, "./output/figures/figure_4.pdf") 

#Figure A1

pop<-tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("pop_sum"), title = c("Total population"), breaks = c(0, 600, 22000, 135000, 330000, 633000, 2000000), 
              labels = c("[0 to 600)", "[600 to 22,000)", "[22,000 to 135,000)", "[135,000 to 633,000)", "[633,000, 2 million)", "[>2 million]"), 
              interval.closure="left", palette="Oranges") +
  tm_layout(legend.position = c("left", "bottom"))
tmap_save(pop, "./output/figures/figure_A1.pdf") 

#Figure A2

child <- tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("inf_mort2019"), title = c("Infant mortality rate"), style = "cont", palette="Blues") +
  tm_layout(legend.position = c("left", "bottom"))
tmap_save(child, "./output/figures/figure_A2.pdf") 

#Figure A7

onmove <- tm_shape(shp5, xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("yintonmove2018", "yintonmove2019"),
              title = c("FMP differs from dep. country 2018", "FMP differs from dep. country 2019"), 
              breaks = c(0, 1, 4, 10, 20, 100, 4000), labels = c("[0 to 1)", "[1 to 4)", "[4 to 10)", "[10 to 20)", "[20 to 100)", "[>100]"), interval.closure="left", palette="Greens") +
  tm_layout(legend.position = c("left", "bottom")) 
tmap_save(onmove, "./output/figures/figure_A7.pdf")  





