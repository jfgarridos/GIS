
#install.packages(spdep)
#install.packages(rgdal)
#import images
library(raster)
library(rgdal)
library(maptools)
library(spdep)
setwd("C:\\UTN\\FICA\\Proyectos\\R aplications\\Landsat8")
tmp <- raster("LC08_L1TP_010060_20190910_20190917_01_T1_ndvi.tiff")
class(tmp)
plot(tmp)
extent(tmp)

