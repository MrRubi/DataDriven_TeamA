######################################################################################################
####################### This file is used to declare common needed functions #########################
######################################################################################################

#function to 
graphicCustomization <- function(graphic, bDelete_x_AxisNames = TRUE)
{
  #delete x-axis names to avoid overlapping
  graphic <- graphic + theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x=element_blank())
  
  #resize the plot title  and the y-axis title (size is measured in points - there are 72.27 points per inch)
  graphic <- graphic + theme(plot.title = element_text(size = rel(2)))
  graphic <- graphic + theme(axis.title.y = element_text(size = rel(1.5)))
  
  #justify plot title
  graphic <- graphic + theme(plot.title = element_text(hjust = 0.5))
  
  #set to black the axises text to be consistent with the titles
  graphic <- graphic + theme(axis.text = element_text(colour = "black", face="bold"))
  
  #set legend border with some useful margin
  if(bDelete_x_AxisNames)
  {
    graphic <- graphic + theme(legend.box.background = element_rect(),legend.box.margin = margin(6, 6, 6, 6), legend.title = element_text(face = "bold")) 
  }
  
  graphic
}