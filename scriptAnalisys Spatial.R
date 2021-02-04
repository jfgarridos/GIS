# ANALISIS ESPACIAL
# ING. FERNANDO GARRIDO s.
# DOCENTE FICA
# CURSO DE GIS using R
#################################
#
# Antes de empezar se debe instalar todos los paquetes para el Análisis Espacial
#
# Activar librerí spatial
# library("spatial", lib.loc="C:/Program Files/R/R-3.5.2/library")
#
# Paquete sf proporciona una interfaz casi directa para las funciones GDAL y GEOS C++
# instalar el paquete sf
#
# Paquete maptools herramienta para manejo de mapas
# install.packages("maptools")
#
# Paquete sfa es parte de sf
# install.packages("sfa")
#
# Paquete tidyverse para funcionar bien con el operador %>%
# install.packages("tidyverse")
#
# mover a la carpeta de trabajo
setwd("C:/UTN/FICA/Proyectos/R aplications")
#
# Paquete que maneja grandes tablas
# install.packages("dplyr")
#
# Paquete para imagenes raster
# install.packages("raster")
#
# Paquete sp permite crear colecciones geométricas
# install.packages("sp")
#
# Paquete tipo Point
# install.packages("POINT")
#
# Paquete geometry
# install.packages("geometry")
#
# AcTIVAR librería sf
library(sf)
###################
# TRABAJAR CON COBERTURA DE PUNTOS
#####################
# # Geometrías Simple Features (sfg)
# Point: coordenadas de un punto en 2, 3 o 4 dimensiones
P <- st_point(c(2,5)) # 2 dimensiones (XY)
class(P)
## [1] "XY"    "POINT" "sfg" 
P <- st_point(c(2,5,17,44),"XYZM") # 4 dimensiones (XYZM)
class(P)
str(P)
# 'XYZM' num [1:4] 2 5 17 4
plot(P, axes = TRUE)
# Multipoint: coordenadas de varios puntos en 2, 3 o 4 dimensiones
# Crea un vector of coordenadas en x
Xs <- c(2,4,5)
# Crea un vector of coordenadas en y
Ys <- c(5,4,8)
# Pega Xs y Ys para crear una tabla de coordenadas
coords <- cbind(Xs,Ys)
print(coords)
# Crea el objeto Multipoint (MP)
MP <- st_multipoint(coords)
plot(MP, axes = TRUE)
class(MP)
class(MP)
## [1] "XY" "MULTIPOINT" "sfg"
print(MP)
# Multipoint en 3 dimensiones
xyz <- cbind(coords,c(17, 22, 31))
print(xyz)
MP <- st_multipoint(xyz)
print(MP)
# Colecciones de Simple Features (sfc)
# Crea varios sfg
P1 <- st_point(c(2,5)); P2 <- st_point(c(4,4)); P3 <- st_point(c(5,8))
# Junta varios sfg en un sfc (colección de simple features)
geometria1 <- st_sfc(P1,P2,P3)
st_sfc(P1,P2, crs = 4326) # Proy geográfica LatLong datum WGS84
# Asociando una geometria sfc con una tabla de atributos (data frame)
# Tabla con ID (campo num) e información adicional (tabla de atributos)
num <- c(1,2,3)
nombre <- c("Pozo","Gasolinera","Pozo")
tabpuntos <- data.frame(cbind(num,nombre))
class(tabpuntos)
print(tabpuntos)
# sf object
SFP <- st_sf(tabpuntos, geometry = geometria1)
class(SFP) # doble clase: simple feature y datafr
print(SFP) # ver columna lista "geometry"
plot(SFP,axes=TRUE)
plot(st_geometry(SFP),axes=TRUE)
# Se puede extraer la tabla de atributos de un objeto SFC con
as.data.frame(SFP)
#Selección de elementos dentro de la cobertura
Pozos <- SFP[nombre=="Pozo",]
## P1 Polígono forestal al SudEste
## Polygon
# Crea una cadena de coordenadas en X
X1 <- c(5,10,10,6,5)
# Crea una cadena de coordenadas en Y
# Ojo tiene que cerrar (último par de coord = primero)
Y1 <- c(0,0,5,5,0)
# Pega X y Y para crear una tabla de coordenadas
c1 <- cbind(X1,Y1)
print(c1)
class(c1)
# Crea el objeto Polygon. Un polygon es una forma simple cerrada
# eventualmente con hueco(s)
P1 <- st_polygon(list(c1))
plot(P1,axes=T)
#
P2 Polígono forestal al NorOeste
# Crea una cadena de coordenadas en X
X2 <- c(0,2,6,0,0)
# Crea una cadena de coordenadas en Y
Y2 <- c(4,4,10,10,4)
# Pega X y Y para crear una tabla de coordenadas
c2 <- cbind(X2,Y2)
# Polígono hueco %%%%%%%%%%%%%% orden coordenadas !!!!!!!!!!!!!
# Crea una cadena de coordenadas en X
X3 <- c(1,1,2,2,1)
# Crea una cadena de coordenadas en Y
# La 1a y última coordenadas se repiten para "cerrar" el polígono
Y3 <- c(5,6,6,5,5)
# Pega X y Y para crear una tabla de coordenadas
c3 <- cbind(X3,Y3)
P2 <- st_polygon(list(c2,c3))
plot(P2,axes=T)
#P4 Polígono de agricultura
c3i <- c3[nrow(c3):1, ] # Invierte el orden de las coordenadas
P4 = st_polygon(list(c3i)) # Esta vez no es hueco
# P5 Polígono de área urbana
X5 <- c(0,5,6,10,10,6,2,0,0)
Y5 <- c(0,0,5,5,10,10,4,4,0)
c5 <- cbind(X5,Y5)
P5 <- st_polygon(list(c5))
plot(P5,axes=T)
#
# Junta varios sfg en un sfc (colección de simple features)
geometria3 <- st_sfc(P1,P2,P4,P5)
#
# Tabla de atributos
ID <- c(1,2,3,4)
code <- c("F","F","U","A")
tipo <- c("Bosque","Bosque","Urbano","Agricultura")
tabpol <- data.frame(cbind(ID,code,tipo))
# sf object
SFPol <- st_sf(tabpol, geometry = geometria3)
plot(SFPol,axes=TRUE)

##
#install.packages("raster") # eliminar comentario para instalar paquete
library(sp)
library(raster)
# Determina la ruta del espacio de trabajo donde está el archivo shp
# .shp: almacena las entidades geométricas de los objetos.
# .shx: almacena el índice de las entidades geométricas.
# .dbf: almacena la tabla de atributos de los objetos.
# Es común encontrar un cuarto archivo con extensión .prj que 
# contiene la información referida al sistema de coordenadas.
# CAMBIAR A SU CARPETA!!
setwd("C:\\UTN\\FICA\\Proyectos\\R aplications\\shapefile")
wd<-getwd()
mx <- st_read("predios_region_Identity.shp")
#
# Pregunta la clase del objeto espacial
class(mx) # Es un simple feature "sf"
summary(mx) # un dataframe con una columna "lista" sobre la geometría
#plotea el mapa (un mapa para cada atributo)
plot(mx, axes = T,cex.axis=0.8) # cex.axis controla tamaño coordenadas
# Para plotear únicamente la geometría
plot(st_geometry(mx))
