# Prerequerimiento: Para poder ejecutar correctamente este script, es necesario disponer del dataframe filtrado
# DataSet_filtered, creado en el script 1_DataFrame_Exploration

# Tenemos 3 protocolos distintos:
# [1] TCP
# [2] UDP
# [3] ICMP
# Vamos a ver cual es el mas usado as? como los protocolos m?s usados.

#include utils file for further use
source("utils.R")

###########################################################################################################################
######################################### QUESTION 2 - PART 1: Most used protocol #########################################
###########################################################################################################################

#filter protocol ('proto') and destination port ('dpt') columns 
protocolAndPortDataSet <- DataSet_filtered[c("proto", "dpt")]

#perform a count by protocol to know the most used
protocol.aggregate <- protocolAndPortDataSet %>% count(proto, sort = T)

#print graphic to see the results
protocol.graphic <- ggplot(protocol.aggregate, aes(x = proto, y = n, fill = proto))
protocol.graphic <- protocol.graphic + geom_bar(stat = "identity", width = 0.5)
protocol.graphic <- protocol.graphic + labs(y = "Used times", x = "Protocols", title = "Most transport protocol used")
protocol.graphic <- graphicCustomization(protocol.graphic)
print(protocol.graphic)

#Another interesting and useful way of watching the previous graphic is through a pie chart

pct <- round(protocol.aggregate$n/sum(protocol.aggregate$n)*100)
lbls <- paste(protocol.aggregate$proto, pct) # add percents to labels
lbls <- paste(lbls,"%",sep="") # ad % to labels 
pie(protocol.aggregate$n,labels = lbls,col=rainbow(length(lbls)),
    main="Pie Chart of most used communication protocols") 

###########################################################################################################################
############################### QUESTION 2 - PART 2: Top 3 most attacked ports by protocol ################################
###########################################################################################################################

#group by protocol and perfomr a count to know how many times a protocl has been attacked
port.aggregate <- protocolAndPortDataSet %>% group_by(proto) %>% count(dpt, sort = T) 

#just ommit the NA value srelated with ICMP
port.aggregate <- na.omit(port.aggregate)

#get the top 3 most attacked ports
port.aggregate <- port.aggregate %>% top_n(3, n)

# 'coerce' the destionation port 'dpt' columns to print it easier in the graphic
port.aggregate$dpt <- as.character(port.aggregate$dpt)

#print graphic to see the results
dodge <- position_dodge(width = 0.9)
portByProtocol.graphic <- ggplot(port.aggregate, aes(x = dpt, y = n, fill = proto))
portByProtocol.graphic <- portByProtocol.graphic + geom_bar(stat = "identity", width = 0.5)
portByProtocol.graphic <- portByProtocol.graphic + labs(y = "Used times", x = "Protocols", title = "Top 3 most attacked ports by protocol")
portByProtocol.graphic <- graphicCustomization(portByProtocol.graphic, FALSE)
print(portByProtocol.graphic)