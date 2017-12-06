#EQUIPO A. Práctica módulo Data Driven Security, máster en cybersecurity management edición 2017-2018. UPC SCHOOL

# Para esta práctica hemos obtenido datos del tráfico de 9 Honeypots del 2013, distribuidos globalmente, 
# entre Marzo y Septiembre. Entre los datos facilitados, encontramos información como el timestamp, 
# el host "atacado", el origen del ataque (tanto localidad como la dirección ip), etc.

# Las preguntas que nos hemos planteado son las siguientes:
#     1 - Determinar cual es el Honeypot más atacado de todos los desplegados, y en base a ese resultado, ver de dónde provienen los ataques
#     2 - ¿ Cuáles son los protocolos y puertos más usados?
#     3 - ¿Existe alguna relación entre la geolocalización del honeypot y el puerto atacado? (OPCIONAL EN FUNCIÓN DEL TIEMPO)

# Integrantes del Equipo A:
  
# - Ángel Rubiño Fernández [MR. T]
# - Álex Gonzalo Rodríguez [Hannibal]
# - José Raúl Jiménez Lama [Fénix]
# - Marc Pallejà Mairena [Murdok]

# En este primer script de R pretendemos cargar el CSV, analizar los datos, limpiar, y quedarnos con un dataframe
# con el que poder trabajar y resolver nuestras cuestiones.



# Comprobación del path actual y carga del csv con los datos
# que queremos analizar
getwd()
Complete_Dataset <- read.csv("~/marx-geo.csv",header = TRUE, check.names = TRUE)

# El dataset dispone de 15 columnas y 451.664 filas (Variables y Observaciónes respectivamente)
dim(Complete_Dataset)


# Las variables en cuestion 
#  [1] "datetime"   "host"       "src"        "proto"      "type"       "spt"       
#  [7] "dpt"        "srcstr"     "cc"         "country"    "locale"     "localeabbr"
#  [13] "postalcode" "latitude"   "longitude" 
names(Complete_Dataset)


# Un primer acercamiento, podría ser observar las mil primeras entradas del dataset, para
# poder hacernos una idea de la información y si se han cargado bien
DataSet_Sample <- head(Complete_Dataset, n=10000)


# Conclusiones obtenidas del comando anterior:
#  1. Aparentemente la variable type tiene siempre valor NA
#  2. Las variables Locale, localeabbr y postal code en determinadas entradas estan vacias
#  3. La longitud de las coordenadas tiene valores negativos. Es eso posible?


# Vamos a produndizar en el campo type, que esta siempre a nulo, para
# comprobar si es cierto o no invocamos la funcion unique
unique(Complete_Dataset$type)



# Nuestra suposicion anterior no es cierta, dispone de los
# siguientes valores: NA  8  3  0 11 13  5 12
# Vamos a ver todas las variables para las observaciones donde type sea diferente de na
DataSet_na_type <- Complete_Dataset[!is.na(Complete_Dataset$type),]
nrow(DataSet_na_type)


# En todos los casos, el protocolo es ICMP, por lo que type debe referirse al tipo de
# comando ICMP enviado.

# Vamos a pasar a analizar el segundo y tercer punto (Las variables Locale, localeabbr y postal code en determinadas 
# entradas estan vacias, y, la longitud de las coordenadas tiene valores negativos.). 
# Para resolver las preguntas de la práctica, necesitamos saber el pais, no queremos profundizar a nivel 
# de localidad, por lo que las variables mencionadas no formaran parte del dataset final con el que vamos a 
# trabajar. 

# Antes de crear un subset de datos donde no aparezcan las variable mencionadas, hay otras que también deberemos
# filtrar, concretamente hablamos de:
#  -src: No entendemos el significado de esta variable
#  -srcstr: No necesitamos saber la @ip origen, ya disponemos de la variable country
#  -cc: De forma análoga a lo mencionado en el punto anterior, no necesitamos esta variable

subset.columns <- c("datetime","host","proto","type","spt","dpt", "country")
DataSet_filtered <- Complete_Dataset[subset.columns]


# Una vez ya tenemos la información que queremos, vamos a comprobar que no hay ningún dato erroneo entre las 
# observaciones (variables sin valor o NA sin motivo justificable). Para ello, miraremos con unique los posibles
# valores que tiene cada variable y comprobaremos si alguno es NA, para los casos que hay muchos
# valores distintos crearemos un dataframe donde guardaremos las observaciones cuyo valor de variable sea NA
# y comprobaremos el tamaño de dicho dataframe

# Correcto
unique(DataSet_filtered$datetime)
aux_datetime <- DataSet_filtered[is.na(DataSet_filtered$datetime),]
nrow(aux_datetime)

# Correcto
unique(DataSet_filtered$host)
aux_host <- DataSet_filtered[is.na(DataSet_filtered$host),]
nrow(aux_host)

# Correcto
unique(DataSet_filtered$proto)
aux_proto <- DataSet_filtered[is.na(DataSet_filtered$proto),]
nrow(aux_proto)

# Correcto. Los valores NA corresponden a las observaciones TCP y UDP, donde no existe el tipo
unique(DataSet_filtered$type)
aux_type <- DataSet_filtered[is.na(DataSet_filtered$type),]
nrow(aux_type)
unique(aux_type$proto)

# Correcto. Los valores NA corresponden a las tramas ICMP donde no aparece el puerto origen ni destino
unique(DataSet_filtered$spt)
aux_spt <- DataSet_filtered[is.na(DataSet_filtered$spt),]
nrow(aux_spt)
unique(aux_spt$proto)

# Correcto. Los valores NA corresponden a las tramas ICMP donde no aparece el puerto origen ni destino
unique(DataSet_filtered$dpt)
aux_dpt <- DataSet_filtered[is.na(DataSet_filtered$dpt),]
nrow(aux_dpt)
unique(aux_dpt$proto)

# El valor 29 de country parece un empty string, hay que filtrarlo
unique(DataSet_filtered$country)
aux_country <- DataSet_filtered[is.na(DataSet_filtered$country),]
nrow(aux_country)

#HACER ALGO PARA ELIMINAR EL EMPTY STRING. NO FUNCIONA
DataSet_filtered <- DataSet_filtered[!stri_isempty(DataSet_filtered$country),]


# LLEGADOS A ESTE PUNTO, PODEMOS EMPEZAR A TRABAJAR EN NUESTRAS PREGUNTAS CON EL DATAFRAME DataSet_filtered
