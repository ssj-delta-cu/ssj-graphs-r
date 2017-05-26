# kc plot by month for all crop types. Kc is calculated by dividing ET by ETo from spatial cimis
# DETAW, ITRC, DisALEXI don't use spatial cimis and may need to swap out the ETo values for those
# three methods if we receive ETo rasters from the groups.

# ETrf (fraction of reference ET)

data <- dsa_legal_data 

data <- data %>% filter(region=="dsa", month=="SEP", wateryear=="2015")

# split eto data from the data frame
eto_data <- data %>% filter(model=="eto")
method_data <- data %>% filter(!model=="eto")

# join eto data to the method_data df 
j <- dplyr::left_join(method_data, eto_data, by=c("wateryear", "month", "cropname"))

j_ETrF <- j %>% mutate(etrf = mean.x/mean.y)

c <- c("Rice", "Corn", "Pears", "Tomatoes", "Walnuts", "Cherries", "Potatoes", "Wet herbaceous/sub irrigated pasture", 
"Alfalfa", "Pasture", "Almonds", "Turf", "Bush Berries", "Forage Grass", "Olives", "Cucurbit", "Truck Crops", "Semi-agricultural/ROW",
"Other Deciduous", "Vineyards", "Pistachios", "Fallow")

j_ETrF_crops <- j_ETrF %>% filter(cropname %in% c)

# factor to change the order of the plot by order of the crop list
j_ETrF_crops$cropname <- factor(j_ETrF_crops$cropname, levels=rev(c))

p <- ggplot(j_ETrF_crops, aes(x=etrf, y=cropname, group=model.x, colour=model.x))+
  geom_point(size=2.5)+
  xlab("ETrF\n(fraction of reference ET)")+
  scale_color_manual(values=model_palette, labels=methods_named_list)+
  theme_bw()+
  theme(panel.border = element_rect(colour = "black", fill="NA", size=1),
        panel.grid.major = element_blank(),
        plot.title = element_text(hjust = 0.5),
        panel.grid.minor = element_blank(),
        legend.position="none", # position of legend or none
        legend.direction="horizontal", # orientation of legend
        legend.title= element_blank(), # no title for legend
        legend.key.size = unit(0.5, "cm"),
        axis.text.x =  element_text(size=12),
        axis.text.y = element_text(size=12),
        axis.title.x = element_text(size=14),
        axis.title.y = element_blank())
p
