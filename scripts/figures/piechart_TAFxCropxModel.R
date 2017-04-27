piechart_TAFxCropxModel <- function(data, wy, aoi){

top_crops <- c("Alfalfa", "Almonds", "Corn", "Fallow", "Pasture", "Potatoes", "Rice",  "Tomatoes", "Vineyards")

af_crops_top_only <- data %>% 
  filter_no_eto() %>% 
  filter(wateryear == wy) %>% 
  filter(region == aoi) %>% 
  filter(include == "yes") %>% 
  filter(cropname %in% top_crops) %>%
  dplyr::group_by(model, cropname) %>% 
  dplyr::summarise(sum_af=sum(crop_acft))

af_crops_others <- data %>% 
  filter_no_eto() %>% 
  filter(wateryear == wy) %>% 
  filter(region == aoi) %>% 
  filter(include == "yes") %>% 
  filter(!cropname %in% top_crops) %>% 
  mutate(cropname = "Other") %>%
  dplyr::group_by(model, cropname) %>% 
  dplyr::summarise(sum_af=sum(crop_acft))

#  merge af_crops_top_only and af_crops_others
af_crops_w_others <- dplyr::union(af_crops_top_only, af_crops_others)


# filter by methods
#af_crops_w_other_single <- af_crops_w_others %>% filter(model == select_model)
af_crops_w_others$model <- toupper(af_crops_w_others$model)

af_crops_w_others_total <- af_crops_w_others %>%  
  dplyr::group_by(model)%>% 
  dplyr::mutate(model_total=sum(sum_af))


ggplot(af_crops_w_others_total, aes(x=model_total/2, y=sum_af, fill=cropname, width=model_total))+
  geom_bar(stat="identity", position = position_fill())+ 
  coord_polar("y") +
  theme_bw() + 
  scale_fill_manual(values=crop_palette)+
  theme(
    axis.text.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5),
    axis.ticks = element_blank(),
    axis.text.x = element_blank(), # plot labels
    legend.position="bottom", # position of legend or none
    legend.direction="horizontal", # orientation of legend
    legend.title= element_blank(), # no title for legend
    legend.key.size = unit(0.5, "cm") # size of legend
  ) +  facet_wrap( ~ model, ncol=7, strip.position = "bottom")+
  theme(strip.background = element_blank(), strip.placement = "outside")
}
