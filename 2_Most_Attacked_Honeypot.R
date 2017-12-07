# Prerequerimiento: Para poder ejecutar correctamente este script, es necesario disponer del dataframe filtrado
# DataSet_filtered, creado en el script 1_DataFrame_Exploration

# Tenemos 9 honeypots distintos, 
# [1] groucho-oregon    groucho-us-east   groucho-singapore groucho-tokyo     groucho-sa        zeppo-norcal     
# [7] groucho-norcal    groucho-eu        groucho-sydney  
# Vamos a analizar el trafico de cada uno.

DataSet_filtered$attacks <- c(1)  # they all occur once right now
hosts <- aggregate(attacks ~ host, data = DataSet_filtered, FUN = sum)

# Uncomment the first time of use 
#install.packages("ggplot2")


#TODO: BORRAR LOS NOMBRES DE LA BASE DE LA GRAFICA, SE SOBREPONEN ENTRE SI, QUEDA HORRIBLE
library(ggplot2)
gg <- ggplot(hosts,aes(x=host,y=attacks, fill = host))
gg <- gg + geom_bar(stat = "identity", width = 0.5)
gg <- gg + labs(y = "Ataques", x = "Honeypots", subtitle = "Ataques recibidos por cada honeypot")
print(gg)


#Los honeypots con mas ataques son en orden ascendente Singapur, Oregon y Tokyo



