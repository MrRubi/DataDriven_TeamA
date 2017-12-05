#Comprobación del path actual y carga del csv con los datos
#que queremos analizar
getwd()
csvcompleto <- read.csv("/home/marc/Descargas/marx-geo.csv",header = TRUE, check.names = TRUE)

#El dataset dispone de 15 columnas y 451.664 filas (Variables y Observaciónes)
dim(csvcompleto)


#Las variables en cuestion 
#[1] "datetime"   "host"       "src"        "proto"      "type"       "spt"       
#[7] "dpt"        "srcstr"     "cc"         "country"    "locale"     "localeabbr"
#[13] "postalcode" "latitude"   "longitude" 
names(csvcompleto)


#Un primer aproach, podria ser observar las veinte primeras entradas del dataset, para
#poder hacernos una idea de la información y si se ha cargado bien
csvrecortado <- head(csvcompleto, n=20)


#Conclusiones obtenidas del comando anterior:
# 1. Aparentemente la variable type tiene siempre valor NA
# 2. Las variables Locale, localeabbr y postal code en determinadas entradas estan vacias
# 3. La longitud de las coordenadas tiene valores negativos. Es eso posible?


#Vamos a produndizar en el campo type, que esta siempre a nulo, para
#comprobar si es cierto o no invocamos la funcion unique
unique(csvcompleto$type)



#Nuestra suposicion anterior no es cierta, dispone de los
#siguientes valores: NA  8  3  0 11 13  5 12
#Vamos a ver todas las variables para las observaciones donde type sea diferente de na
csvcompleto_na_type <- csvcompleto[!is.na(csvcompleto$type),]
nrow(csvcompleto_na_type)


#En todos los casos, el protocolo es ICMP, por lo que type debe referirse al tipo de
#comando ICMP enviado. Otro dato que favorece esta hipotesis es que en las 20 
#primeras muestras, el protocolo siempre era TCP Y UDP