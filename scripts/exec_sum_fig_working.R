  
  data <- dsa_legal_data %>% filter(region=="dsa")
  
  top_crops <- c("Alfalfa", "Corn", "Pasture")
  
  
  af_crops_top_only <- data %>% 
    filter_no_eto() %>% 
    filter(include == "yes") %>% 
    filter(cropname %in% top_crops) %>%
    dplyr::group_by(model, cropname, wateryear) %>% 
    dplyr::summarise(sum_af=sum(crop_acft))
  
  af_crops_others <- data %>% 
    filter_no_eto() %>% 
    filter(include == "yes") %>% 
    filter(!cropname %in% top_crops) %>% 
    mutate(cropname = "Other") %>%
    dplyr::group_by(model, cropname, wateryear) %>% 
    dplyr::summarise(sum_af=sum(crop_acft, na.rm = TRUE))
  
  # SIMS
  
  # sims doesn't include wet herbaceous or semi ag so we'll data 
  # that represents the average of all methods for herbaceous/sub irrigated pasture.
  
  # To calculate the estimate, take the total acre-feet for the sims and subtract the values for the herb and semi-ag classes. Then,
  # calculate the mean value from the other models for these two classes and add it to the total.
  
  # total acre-feet for sims for the two classes (to subtract from the total since the EE output has a non-zero value)
  sims_herb_semi <- data %>% filter(model=="sims", level_2 %in% c(2008, 913)) %>%
    dplyr::group_by(wateryear) %>% 
    dplyr::summarise(sum_wetherb_semiag=sum(crop_acft))
  
  # Calculate the average for herb + semi-ag for the other models for the two regions
  mean_herb_semi <- data %>% filter(!model=="sims", !model=="eto") %>%
    filter(level_2 %in% c(2008, 913)) %>%
    dplyr::group_by(model, wateryear) %>%
    dplyr::summarise(sum_af=sum(crop_acft)) %>%
    dplyr::group_by(wateryear) %>%
    dplyr::summarise(mean_2classes=mean(sum_af))
  
  # get sims TAF results for DSA
  sims <- af_crops_others %>% filter(model=="sims")
  
  # join the sims sum for herb_semi and the mean value for herb_semi for the two regions
  sims_joined <- dplyr::left_join(dplyr::left_join(sims, sims_herb_semi, by="wateryear"), mean_herb_semi, by="wateryear")
  
  # subtract the herb_sumi total from the orignal value and add the mean for the two crops
  sims_joined_est <- sims_joined %>% mutate(sum_af_est=(sum_af - sum_wetherb_semiag + mean_2classes))
  
  # clean up columns by droping intermediate columns and renaming estimate to sum_af
  sims_est <- sims_joined_est %>% dplyr::select(c(model, wateryear, sum_af_est)) %>% rename(sum_af=sum_af_est)
  
  # remove sims from af_crop_filter and add in the new estimated results
  af_wo_sims <- af_crops_others %>% filter(!model=="sims")
  af_crops_others2 <- bind_rows(af_wo_sims,  sims_est)
  
  
  
  
  
  
  #  merge af_crops_top_only and af_crops_others
  af_crops_w_others <- dplyr::union(af_crops_top_only, af_crops_others2)
  
  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x/1000
  }
  
  
  # add the ensemble average value
  avgs <- af_crops_w_others %>% group_by(wateryear, cropname)%>%summarize(sum_af=mean(sum_af)) %>% mutate(model="Average")
  af_crops_w_others_avg <- bind_rows(af_crops_w_others, avgs)
  
  
  af_crops_w_others_avg$model <- factor(af_crops_w_others_avg$model, levels=c("calsimetaw", "detaw", "disalexi", "itrc", "sims", "ucdmetric", "ucdpt", "Average"))
  levels(af_crops_w_others_avg$model) <- c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT", "Average")
  af_crops_w_others_avg$cropname <- factor(af_crops_w_others_avg$cropname, levels=rev(c("Alfalfa", "Corn", "Pasture", "Other")))
  
  
  p <- ggplot(af_crops_w_others_avg, aes(x=factor(wateryear), y=sum_af, fill=cropname))+geom_bar(stat = "identity") + 
    theme_bw() + 
    scale_fill_manual(values=crop_palette)+
    scale_y_continuous(labels = axis_units, limits = c(0, 1600000)) +
    ylab("Thousands Acre-Feet") +
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
          axis.line.y = element_line(color="black", size = 1))+
    facet_grid(~model, switch = 'x')+ # manually add in axis
    theme(strip.background = element_blank(), 
          strip.placement = "bottom", 
          strip.text.x = element_text(size = 10),
          axis.line.x = element_line(color="black", size = 1),
          axis.line.y = element_line(color="black", size = 1))+
    guides(fill = guide_legend(reverse = TRUE))
    p
  
  
