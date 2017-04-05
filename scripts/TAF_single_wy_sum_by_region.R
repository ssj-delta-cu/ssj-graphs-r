# Total Acre-feet for crops summed over entire water year figure & table

# load data (rds created in json2df.R)
data <- readRDS("wy_2015.rds")

# load helper function
source("scripts/helper_functions.R")

# Summarize the wy total acre feet by crop type
acre_feet_by_crop <- data %>% dplyr::group_by(model, region, cropname, wateryear, include) %>%  dplyr::summarise(sum_af=sum(crop_acft)) 

# summarize total acre-ft using all landtypes
af_all_lu <- data %>% 
  dplyr::group_by(model, region, wateryear) %>% 
  dplyr::summarise(sum_af=sum(crop_acft)) 

# summarize total acre-ft just using crops (ie include = "yes")
af_crops <- data %>% filter(include == "yes") %>%
  dplyr::group_by(model, region, wateryear) %>% 
  dplyr::summarise(sum_af=sum(crop_acft)) 



##################################################################################

# Plot that summarizes the af_crops by the two regions

# filter by wy 2015 data
af_crops_wy15 <- af_crops %>% filter(wateryear == 2015) %>% filter

# manually chuck results for models that don't conver legal delta
af_crops_wy15_filter <- af_crops_wy15 %>% filter(model!="eto") %>%
  filter(model!="calsimetaw" & model!="detaw" & model!="sims" | region!="legal")


axis_units <-function(x){
  x/1000
}


p <- ggplot(af_crops_wy15_filter, aes(x=model, y=sum_af, colour=region))+
  geom_point(size=2) +
  ggtitle("Acre-feet totals for crops summed over 2015 water year") +
  scale_y_continuous(labels = axis_units, limits = c(1000000, 2000000)) +
  ylab("Thousands Acre-Feet") +
  scale_x_discrete(labels=c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT"))+
  scale_color_manual(labels = c("Delta Service Area", "Legal Delta"), 
                     values = c('#3366cc', "#dc3912")) +
  theme_bw() +  
  theme(panel.border = element_blank(),
        panel.grid.major = element_blank(),
        plot.title = element_text(hjust = 0.5),
        panel.grid.minor = element_blank(),
        axis.title.x = element_blank(),
        legend.position="bottom", # position of legend or none
        legend.direction="horizontal", # orientation of legend
        legend.title= element_blank(), # no title for legend
        legend.key.size = unit(0.5, "cm"), # size of legend
        axis.line.x = element_line(color="black", size = 1),
        axis.line.y = element_line(color="black", size = 1)) # manually add in axis
p


# get summary table (by making data untidy)
af_crops_wy15_filter_dsa <- af_crops_wy15_filter %>% filter(region=="dsa") %>% ungroup() %>% select(model, sum_af)
af_crops_wy15_filter_legal <- af_crops_wy15_filter %>% filter(region=="legal") %>% ungroup() %>% select(model, sum_af)

j <- full_join(af_crops_wy15_filter_dsa, af_crops_wy15_filter_legal, by="model")
colnames(j) <- c("Method", "DSA", "LEGAL")
j
print.data.frame(j)
