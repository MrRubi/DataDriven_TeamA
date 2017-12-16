# Prerequerimiento: Para poder ejecutar correctamente este script, es necesario disponer del dataframe filtrado
# DataSet_filtered, creado en el script 1_DataFrame_Exploration

#Instalamos los paquetes necesarios primero, una vez instalados, no hará falta volverlos a instalar
install.packages("ggmap")
installed.packages(ggplot2)

#Una vez instalados los paquetes, los cargamos para su posterior uso
library("ggmap")
library(ggplot2)

#Nos quedamos con las columnas que nos hagan falta, en este caso queremos representar de donde vienen los ataques
#y nos centraremos solo en la longitud y latitud para representar de donde provienen, para ello seleccionaremos estas 2 columnas
#y las pondremos en la variable "localizacion"
coordenadas <- c("latitude", "longitude")
localizacion <- Complete_Dataset[coordenadas]

#Filtramos los NA omitiéndolos y luego verificamos si siguen apareciendo en nuestros datos
localizacion <- na.omit(localizacion)
nrow(localizacion[is.na(localizacion$latitude),])

#La latitud solo puede tener valores a 90 (según la escala de Microsoft https://msdn.microsoft.com/en-us/library/aa578799.aspx)
#Por lo tanto, elegiremos este valor, para descartar valores mucho mayores a esta escala que hagan que no se representen
#Correctamente los ataques en el mapa del mundo
localizacion <- localizacion[localizacion$latitude<90,]

#Guardamos las columnas de longitud y latitud una vez filtradas y procesadas, en las variables "longitud" y "latitud" respectivamente
longitud <- localizacion$longitude
latitud <- localizacion$latitude

#Realizamos la función mapWorld a través de ggplot, con los parámetros necesarios para crear el mapa, y lo guardaremos en la variable mp 
mp <- NULL
mapWorld <- borders("world", colour="gray50", fill="gray50") # create a layer of borders
mp <- ggplot() +   mapWorld

#Mostramos en el mapa, nuestras longitudes y latitudes representándolas en el mapa como puntos naranjas con transparencias
mp <- mp+ geom_point(aes(x=longitud, y=latitud) ,color=rgb(1,0.65,0,0.2), size=0.5) 
mp