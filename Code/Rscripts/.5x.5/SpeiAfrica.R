
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

#This R-Script imports an NC file containing the SPEI03 data 
#It then assigns the centroids to a grid shapefile in Africa with a 60 arc-minute resolution
#You an change spei03 for spei01 and spei06 as well 

#----------------------------------------------------------------------------------------------------------------------
#Read cell coordinates 
#----------------------------------------------------------------------------------------------------------------------

install.packages('raster')
install.packages('sf')
install.packages('rgdal')
install.packages('dplyr')
install.packages('spData')

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

#Open nc file as raster 

spei.brick <- brick('./_orig/SPEIbase-2.5.1/outputNcdf/spei12.nc')
 
#Check extent of coordinates (should be -180, 180) if 360 check stackflow: https://stackoverflow.com/questions/50204653/how-to-extract-the-data-in-a-netcdf-file-based-on-a-shapefile-in-r

extent(spei.brick)

#Check projection 

crs(spei.brick)  

#Check projection of shapefile 

shp <- readOGR('./shapefiles/Africa5x5/Africa5x5grid.shp')

plot(shp)

#shp = spTransform(shp, crs(pre1.brick))  #If the projections are different, adjust them

#Use shapefile as mask of the raster brick -- extract information for Africa

spei.mask <- mask(spei.brick, shp)

#Convert to data frame 

spei.df = as.data.frame(spei.mask[[1381:1428]], xy=TRUE)  #Specify the columns to extract from database

spei.df = spei.df[complete.cases(spei.df),]
head(spei.df)

names(spei.df) <- c("lat", "lon", 
                     "Jan2016"	,	"Feb2016"	,	"Mar2016"	,	"Apr2016"	,	"May2016"	,	"Jun2016"	,	"Jul2016"	,	"Aug2016"	,	"Sep2016"	,	"Oct2016"	,	"Nov2016"	,	"Dec2016" ,
                     "Jan2017"	,	"Feb2017"	,	"Mar2017"	,	"Apr2017"	,	"May2017"	,	"Jun2017"	,	"Jul2017"	,	"Aug2017"	,	"Sep2017"	,	"Oct2017"	,	"Nov2017"	,	"Dec2017" ,
                     "Jan2018"	,	"Feb2018"	,	"Mar2018"	,	"Apr2018"	,	"May2018"	,	"Jun2018"	,	"Jul2018"	,	"Aug2018"	,	"Sep2018"	,	"Oct2018"	,	"Nov2018"	,	"Dec2018" ,
                     "Jan2019"	,	"Feb2019"	,	"Mar2019"	,	"Apr2019"	,	"May2019"	,	"Jun2019"	,	"Jul2019"	,	"Aug2019"	,	"Sep2019"	,	"Oct2019"	,	"Nov2019"	,	"Dec2019")

coordinates(spei.df) <- ~lat+lon

plot(shp, border = "grey")
points(spei.df, col = "red", cex = 5) 

#Make sure the two files share the same CRS

crs(shp)  
crs(spei.df)  
spei.df@proj4string <- shp@proj4string

crs(shp)  
crs(spei.df) 

#Merge datapoints 

out <- over(shp, spei.df, fn=mean) 

shp@data <- cbind(shp@data, out)

#Convert full shape file to data frame 

shp.df <- as(shp, "data.frame")

#setwd("./Rdata")

write.csv(shp.df, file = "./Rdata/spei12_cells.csv")

#----------------------------------------------------------------------------------------------------------------------------------
# Produce maps 
#----------------------------------------------------------------------------------------------------------------------------------

install.packages('tmap')

library(tmap)

setwd(".../doc/")

#Maps per month 

T1 <- 
  tm_shape(shp) + 
  tm_polygons(c("Jan2019", "Feb2019", "Mar2019", "Apr2019"), style = "cont", title = c("SPEI 01-17", "SPEI 02-17", "SPEI 03-17", "SPEI 04-17"),  palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))

tmap_save(T1, "./SPEI03_T1_2017.pdf")

T2 <- 
  tm_shape(shp) + 
  tm_polygons(c("May2019", "Jun2019", "Jul2019", "Aug2019"), style = "cont", title = c("SPEI 05-17", "SPEI 06-17", "SPEI 07-17", "SPEI 08-17"),  palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))

tmap_save(T2, "./SPEI03_T2_2017.pdf")

T3 <- 
  tm_shape(shp) + 
  tm_polygons(c("Sep2019", "Oct2019", "Nov2019", "Dec2019"), style = "cont", title = c("SPEI 09-17", "SPEI 10-17", "SPEI 11-17", "SPEI 12-17"),  palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))

tmap_save(T3, "./SPEI03_T3_2017.pdf")

#Maps: last month of every quarter 

ByQ2017 <- tm_shape(shp) + 
  tm_polygons(c("Mar2017", "Jun2017", "Sep2017", "Dec2017"), style = "cont", title = c("SPEI March-17", "SPEI June-17", "SPEI September-17", "SPEI December-17"),  palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))
tmap_save(ByQ2017, "./SPEI03_byQ_2017.pdf")

ByQ2018 <- tm_shape(shp,  xlim=c(-20, 25),  ylim=c(-10, 30)) + 
  tm_polygons(c("Mar2018", "Jun2018", "Sep2018", "Dec2018"), style = "cont", title = c("SPEI March-18", "SPEI June-18", "SPEI September-18", "SPEI December-18"),  palette="RdYlBu") +
  tm_layout(legend.position = c("left", "bottom"))
tmap_save(ByQ2018, "./SPEI03_byQ_2018.pdf")
