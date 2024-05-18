
#Project: Climate Anomalies and International Migration: A Disaggregated Analysis for West Africa
#Authors:	Martínez Flores, Milusheva, Reichert & Reitmann
#Year:		2024

## load packages

library(rgdal)
library(raster)
library(rgeos)

#Change path to data folder

setwd("")

## import data

spy_poly <- readOGR('./shapefiles/Africa_Continent/Africa.shp')
spy_grid <- readOGR('./shapefiles/Africa/raster_Africa.shp')

crs(spy_grid)
crs(spy_poly)
spy_grid@proj4string <- spy_poly@proj4string

#centroid of cell is in which part of shapefile 

poly_OVER_grid <- over(spy_grid, spy_poly)
spy_grid@data <- cbind(spy_grid@data, poly_OVER_grid)

spy_grid.df <- as(spy_grid, "data.frame")

write.csv(spy_grid.df, file = "./Rdata/country_cells_centroids.csv")

#-------------------------------------------------------------------------
#By minimum distance 
#------------------------------------------------------------------------

spy_poly <- readOGR('./shapefiles/Africa_Continent/Africa.shp')
spy_grid <- readOGR('./shapefiles/Africa/raster_Africa.shp')

## per grid cell, identify ID covering largest area

lst <- lapply(1:length(spy_grid), function(i) {
  
  # create polygons subset based on current grid cell
  
  spy_poly_crp <- crop(spy_poly, spy_grid[i, ])
  
  # case 1: no polygon intersects with current cell
  
  if (is.null(spy_poly_crp)) {
    out <- data.frame(matrix(ncol = ncol(spy_poly), nrow = 1))
    names(out) <- names(spy_poly)
    return(out)
    
    # case 2: one polygon intersects with current cell  
    
  } else if (nrow(spy_poly_crp@data) == 1)  {
    return(spy_poly_crp@data) 
    
    # case 3: multiple polygons intersect with current cell
    
    # -> choose sub-polygon with largest area
  } else {
    areas <- gArea(spy_poly_crp, byid = TRUE)
    index <- which.max(areas)
    return(spy_poly_crp@data[index, ])
  }
})

## to 'data.frame'

do.call("rbind", lst)
