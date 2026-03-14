
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

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

plot(shp5)

#Use shapefile as mask of the raster brick -- extract information for Africa

sm.mask <- mask(sm.brick, shp5)

#Convert to data frame 

sm.df = as.data.frame(sm.brick, xy=TRUE)  #Specify the columns to extract from database

sm.df = sm.df[complete.cases(sm.df),]
head(sm.df)

coordinates(sm.df) <- ~x+y

sm.df@proj4string <- shp5@proj4string

#Merge datapoints 

out <- over(shp5, sm.df, fn=mean) 

shp5@data <- cbind(shp5@data, out)

#Convert full shape file to data frame 

shp.df <- as(shp5, "data.frame")

#setwd("./Rdata")

write.csv(shp.df, file = "./Rdata/.5x.5/moisture_cells.csv")  

#The file above is read and prepared in stata 

setwd(".../data/")

#Read shape file 

shp5 <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

moisture <- read.csv('./Rdata/.5x.5/moisture_cells_year.csv')

shp5@data <- cbind(shp5@data, moisture)

shp.fmp <- as(shp5, "data.frame")

mig <- read.csv('./Rdata/.5x.5/final_sma_mig.csv')

shp5@data <- cbind(shp5@data, mig)

#----------------------------------------------------------------------------------------------------------------------------------
# Produce maps 
#----------------------------------------------------------------------------------------------------------------------------------

library(tmap)

setwd(".../doc")

pop<-tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("pop_sum"), title = c("Total population"), breaks = c(0, 600, 22000, 135000, 330000, 633000, 2000000), 
              labels = c("[0 to 600)", "[600 to 22,000)", "[22,000 to 135,000)", "[135,000 to 633,000)", "[633,000, 2 million)", "[>2 million]"), 
              interval.closure="left", palette="Oranges") +
  tm_layout(legend.position = c("left", "bottom"))
tmap_save(pop, "./pop_5x5.pdf") 

child <- tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("inf_mort2019"), title = c("Infant mortality rate"), style = "cont", palette="Blues") +
  tm_layout(legend.position = c("left", "bottom"))
tmap_save(child, "./Inf_mort_5x5.pdf") 

#Maps per year 
 
sma <- tm_shape(shp5, xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("ylrsma2018", "ylrsma2019", "ylrsma_gs2018", "ylrsma_gs2019"), 
              title = c("SMA index", "SMA index", "SMA index", "SMA index"), 
              style = "cont", n=6, midpoint=0, breaks = c(-2,-1,0,1,2)) +
  tm_layout(legend.position = c("left", "bottom"), panel.labels = c("A. Average SMA in 2018", "B. Average SMA in 2019", "C. Average SMA in 2018: Growing Season Months", "D. Average SMA in 2019: Growing Season Months"))  
tmap_save(sma, "./sma_2018_2019_5x5.pdf") 

mig <- tm_shape(shp5, xlim=c(-20, 25),  ylim=c(-10, 30)) + 
   tm_polygons(c("ymigafrica2018", "ymigafrica2019", "ymigeurope2018", "ymigeurope2019"),
                 title = c("Intra-region 2018", "Intra-region 2019", "Europe 2018", "Europe 2019"), 
               breaks = c(0, 1, 4, 10, 20, 100, 4000), labels = c("[0 to 1)", "[1 to 4)", "[4 to 10)", "[10 to 20)", "[20 to 100)", "[>100]"), interval.closure="left", palette="Blues") +
   tm_layout(legend.position = c("left", "bottom")) 
 tmap_save(mig, "./mig_intra_inter_2018_2019_5x5.pdf") 

onmove <- tm_shape(shp5, xlim=c(-20, 25),  ylim=c(-10, 30)) + 
 tm_polygons(c("yintonmove2018", "yintonmove2019"),
             title = c("FMP differs from dep. country 2018", "FMP differs from dep. country 2019"), 
             breaks = c(0, 1, 4, 10, 20, 100, 4000), labels = c("[0 to 1)", "[1 to 4)", "[4 to 10)", "[10 to 20)", "[20 to 100)", "[>100]"), interval.closure="left", palette="Greens") +
  tm_layout(legend.position = c("left", "bottom")) 
tmap_save(onmove, "./fmp_dif_depcountry_2018_2019_5x5.pdf")  

allmig <- tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
   tm_polygons(c("ymigrant2018", "ymigrant2019"), 
  title = c("No. of migrants", "No. of migrants"), 
  breaks = c(0, 1, 4, 10, 20, 100, 4000), labels = c("[0 to 1)", "[1 to 4)", "[4 to 10)", "[10 to 20)", "[20 to 100)", "[>100]"), interval.closure="left", palette="Blues") +
   tm_layout(legend.position = c("left", "bottom"), panel.labels = c("A. Total Number of Migrants in 2018", "B. Total Number of Migrants in 2019"))
tmap_save(allmig, "./fmp_tot_mig_2018_2019_5x5.pdf")  

intmig <- tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("yinternational2018", "yinternational2019"), 
              title = c("Total migration 2018", "Total migration 2019"), 
              breaks = c(0, 1, 4, 10, 20, 100, 4000), labels = c("[0 to 1)", "[1 to 4)", "[4 to 10)", "[10 to 20)", "[20 to 100)", "[>100]"), interval.closure="left", palette="Greens") +
  tm_layout(legend.position = c("left", "bottom"))
tmap_save(intmig, "./fmp_int_mig_2018_2019_5x5.pdf")  

# Other

tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("smi2018", "smi2019"), title = c("SMI 2018", "SMI 2019"), style = "cont", palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))

tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("lrm_smi2018", "lrm_smi2019"), style = "cont", palette="RdYlBu", colorNULL="grey") +
  tm_layout(legend.position = c("left", "bottom"))

tm_shape(shp5,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("sma2018", "sma2019"), style = "cont", n=7, midpoint=0) +
  tm_layout(legend.position = c("left", "bottom")) 
