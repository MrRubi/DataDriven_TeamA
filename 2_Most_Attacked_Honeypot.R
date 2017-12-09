# Prerequerimiento: Para poder ejecutar correctamente este script, es necesario disponer del dataframe filtrado
# DataSet_filtered, creado en el script 1_DataFrame_Exploration

# Tenemos 9 honeypots distintos, 
# [1] groucho-oregon    groucho-us-east   groucho-singapore groucho-tokyo     groucho-sa        zeppo-norcal     
# [7] groucho-norcal    groucho-eu        groucho-sydney  
# Vamos a analizar el trafico de cada uno.

#include utils file for further use
source("utils.R")

#Intall needed packages (uncomment the first time of use)
#install.packages("ggplot2")
#install.packages("dplyr")

#load needed libraries
library(ggplot2)
library(dplyr)

###########################################################################################################################
####################################### QUESTION 1 - PART 1: Most attacked honeypots ######################################
###########################################################################################################################

DataSet_filtered$attacks <- c(1)  # they all occur once right now
hosts <- aggregate(attacks ~ host, data = DataSet_filtered, FUN = sum)

#reorder funtion is used to print attacks in ascending order
attacksByHoneypot.graphic <- ggplot(hosts, aes(x = reorder(host, attacks), y=attacks, fill = host))
attacksByHoneypot.graphic <- attacksByHoneypot.graphic + geom_bar(stat = "identity", width = 0.5)
attacksByHoneypot.graphic <- attacksByHoneypot.graphic + labs(y = "Attacks", x = "Honeypots", title = "Received attacks by honeypot")
attacksByHoneypot.graphic <- graphicCustomization(attacksByHoneypot.graphic)
print(attacksByHoneypot.graphic)

#Los honeypots con mas ataques son en orden ascendente Singapur, Oregon y Tokyo

###########################################################################################################################
####################################### QUESTION 1 - PART 2: Top 3 attacks location #######################################
###########################################################################################################################

#group by host and country to know which country has performed more attacks adding the attacks entries and getting the top 3
mostAttackedHostsByCountry <- DataSet_filtered %>% group_by(host, country) %>% summarise(attacks = sum(attacks)) %>% top_n(3, attacks)

#print graphic to see the results
dodge <- position_dodge(width = 0.9)
attacksLocation.graphic <- ggplot(mostAttackedHostsByCountry, aes(x = host, y = attacks, fill = country)) 
attacksLocation.graphic <- attacksLocation.graphic + geom_bar(stat = "identity", position = position_dodge())
attacksLocation.graphic <- attacksLocation.graphic + labs(y = "Attacks", x = "Honeypots", title = "Top 3 attacks location")

bDelete_x_AxisNames = FALSE
attacksLocation.graphic <- graphicCustomization(attacksLocation.graphic, FALSE)
print(attacksLocation.graphic)





