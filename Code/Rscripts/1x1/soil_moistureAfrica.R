
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

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')

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

#Convert full shape file to data frame 

shp.df <- as(shp, "data.frame")

#setwd("./Rdata")

write.csv(shp.df, file = "./Rdata/moisture_cells.csv")  

#The file above is read and prepared in stata 

#Check projection of shapefile 

shp <- readOGR('./shapefiles/Africa/raster_Africa.shp')

moisture <- read.csv('./Rdata/moisture_cells_year.csv')

shp@data <- cbind(shp@data, moisture)

#Check projection of shapefile 

mig <- read.csv('./Rdata/final_sma_mig.csv')

shp@data <- cbind(shp@data, mig)

#----------------------------------------------------------------------------------------------------------------------------------
# Produce maps 
#----------------------------------------------------------------------------------------------------------------------------------

library(tmap)

setwd(".../doc/")

tm_shape(shp,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("smi2018", "smi2019"), title = c("SMI 2018", "SMI 2019"), style = "cont", palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))

tm_shape(shp,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("lrm_smi2018", "lrm_smi2019"), style = "cont", palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))

tm_shape(shp,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("sma2018", "sma2019"), style = "cont", n=7, midpoint=0) +
  tm_layout(legend.position = c("left", "bottom")) 

#Maps per year

sma <- tm_shape(shp, xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("ylrsma2018", "ylrsma2019", "ylrsma_gs2018", "ylrsma_gs2019"), 
              title = c("SMA 2018", "SMA 2019", "SMA GS 2018", "SMA GS 2019"), 
              style = "cont", n=6, midpoint=0) +
  tm_layout(legend.position = c("left", "bottom")) 
tmap_save(sma, "./sma_2018_2019.pdf") 

mig <- tm_shape(shp, xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("ymigafrica2018", "ymigafrica2019", "ymigeurope2018", "ymigeurope2019"),
              title = c("Intra-region 2018", "Intra-region 2019", "Europe 2018", "Europe 2019"), 
              breaks = c(0, 1, 10, 50, 200, 500, 4000), labels = c("[0 to 1)", "[1 to 10)", "[10 to 50)", "[50 to 200)", "[200 to 500)", "[>500]"), interval.closure="left", palette="Blues") +
  tm_layout(legend.position = c("left", "bottom")) 
tmap_save(mig, "./mig_intra_inter_2018_2019.pdf") 

onmove <- tm_shape(shp, xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("yintonmove2018", "yintonmove2019"),
              title = c("FMP differs from dep. country 2018", "FMP differs from dep. country 2019"), 
              breaks = c(0, 1, 10, 50, 200, 500, 4000), labels = c("[0 to 1)", "[1 to 10)", "[10 to 50)", "[50 to 200)", "[200 to 500)", "[>500]"), interval.closure="left", palette="Blues") +
  tm_layout(legend.position = c("left", "bottom")) 
tmap_save(onmove, "./fmp_dif_depcountry_2018_2019.pdf")  

allmig <- tm_shape(shp,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("ymigrant2018", "ymigrant2019"), 
              title = c("Total migration 2018", "Total migration 2019"), 
              breaks = c(0, 1, 10, 50, 200, 500, 4000), labels = c("[0 to 1)", "[1 to 10)", "[10 to 50)", "[50 to 200)", "[200 to 500)", "[>500]"), interval.closure="left", palette="Blues") +
  tm_layout(legend.position = c("left", "bottom"))
tmap_save(allmig, "./fmp_tot_mig_2018_2019.pdf")  

tm_shape(shp) + 
  tm_polygons(c("sma2018m12", "sma2019m12"), title = c("SMA 2018", "SMA 2019"), style = "cont", n=7, midpoint=0) +
  tm_layout(legend.position = c("left", "bottom")) 
 