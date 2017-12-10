# Prerequerimiento: Para poder ejecutar correctamente este script, es necesario disponer del dataframe filtrado
# DataSet_filtered, creado en el script 1_DataFrame_Exploration

# En la primera pregunta hemos visto los honeypots mas atacados, y el origen de los mismos. En la segunda, hemos 
# analizado el protocolo mas usado en los ataques y el correspondiente puerto. En esta última pregunta, pretendemos
# relacionar ambos conceptos. Existe alguna relación entre la localizacion del honeypot y el puerto utilizado?

###########################################################################################################################
####################################### QUESTION 3 - PART 1: Port used in the attack for each Honeypot TCP ####################
###########################################################################################################################


#include utils file for further use
source("utils.R")

#Intall needed packages (uncomment the first time of use)
#install.packages("ggplot2")
#install.packages("dplyr")

#load needed libraries
library(ggplot2)
library(dplyr)

#filter host, protocol ('proto') and destination port ('dpt') columns 
host_protocol_dataframe <- DataSet_filtered[c("host", "proto", "dpt")]

#Subset that correlates the host with the TCP protocol and the ports used
host_tcp <- subset(host_protocol_dataframe, proto == "TCP")

#group by protocol and perfomr a count to know how many times a protocl has been attacked
host_tcp_port.aggregate <- host_tcp %>% group_by(host) %>% count(dpt, sort = T)

# As there are a lot of ports used, the graphic can't be correctly seen, so, as we did in the second question,
# we are going just to compare the three 5 most used ports
host_tcp_port.aggregate <- host_tcp_port.aggregate %>% top_n(5, n)

# 'coerce' the destionation port 'dpt' columns to print it easier in the graphic
host_tcp_port.aggregate$dpt <- as.character(host_tcp_port.aggregate$dpt)

# set up a ggplot instance, pretty color for each host
host_tcp_port_gg <- ggplot(host_tcp_port.aggregate, aes(x = dpt, y = n, fill = host))
# add in a simple bar plot
host_tcp_port_gg <- host_tcp_port_gg + geom_bar(stat = "identity", width = 0.5)
# create individual plots for each host with free scales
host_tcp_port_gg <- host_tcp_port_gg + facet_wrap(~host, scales = "free")
# simple theme, with no legend
host_tcp_port_gg <- host_tcp_port_gg + theme(legend.position = "none")
host_tcp_port_gg <- graphicCustomization(host_tcp_port_gg, FALSE)
print(host_tcp_port_gg)


###########################################################################################################################
####################################### QUESTION 3 - PART 2: Port used in the attack for each Honeypot UDP ####################
###########################################################################################################################

#Subset that correlates the host with the TCP protocol and the ports used
host_udp <- subset(host_protocol_dataframe, proto == "UDP")

#group by protocol and perfomr a count to know how many times a protocl has been attacked
host_udp.aggregate <- host_udp %>% group_by(host) %>% count(dpt, sort = T)

# As there are a lot of ports used, the graphic can't be correctly seen, so, as we did in the second question,
# we are going just to compare the three 5 most used ports
host_udp.aggregate <- host_udp.aggregate %>% top_n(5, n)

# 'coerce' the destionation port 'dpt' columns to print it easier in the graphic
host_udp.aggregate$dpt <- as.character(host_udp.aggregate$dpt)

# set up a ggplot instance, pretty color for each host
host_udp_port_gg <- ggplot(host_udp.aggregate, aes(x = dpt, y = n, fill = host))
# add in a simple bar plot
host_udp_port_gg <- host_udp_port_gg + geom_bar(stat = "identity", width = 0.5)
# create individual plots for each host with free scales
host_udp_port_gg <- host_udp_port_gg + facet_wrap(~host, scales = "free")
# simple theme, with no legend
host_udp_port_gg <- host_udp_port_gg + theme(legend.position = "none")
host_udp_port_gg <- graphicCustomization(host_udp_port_gg, FALSE)
print(host_udp_port_gg)