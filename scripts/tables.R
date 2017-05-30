# tables

source("scripts/helper_functions.R")

# summary table for figure # 5 TAF summed over water year

table_taf_wy_regions <- function(data, wy){
  # summarize total acre-ft just using crops (ie include = "yes")
  af_crops <- data %>% filter(include == "yes", crop_acft > 0) %>%
    dplyr::group_by(model, region, wateryear) %>% 
    dplyr::summarise(sum_af=sum(crop_acft)) %>% filter(wateryear == wy)
  
  # manually chuck results for models that don't conver legal delta
  af_cover <- af_crops %>% filter(model!="eto") %>%
    filter(model!="calsimetaw" & model!="detaw" | region!="legal")
  
  # sims doesn't include wet herbaceous or semi ag so we'll add a point
  # that represents the average of all methods for herbaceous/sub irrigated pasture.
  # To calculate the estimate, take the total acre-feet for the sims and subtract the values for the herb and semi-ag classes. Then,
  # calculate the mean value from the other models for these two classes and add it to the total.
  
  # total acre-feet for sims for the two classes (to subtract from the total since the EE output has a non-zero value)
  sims_herb_semi <- data %>% filter(model=="sims", wateryear==wy, level_2 %in% c(2008, 913)) %>%
    dplyr::group_by(region) %>%
    dplyr::summarise(sum_wetherb_semiag=sum(crop_acft))
  
  # Calculate the average for herb + semi-ag for the other models for the two regions
  mean_herb_semi <- data %>% filter(!model=="sims", !model=="eto") %>%
    filter(wateryear==wy, level_2 %in% c(2008, 913)) %>%
    dplyr::group_by(model, region) %>%
    dplyr::summarise(sum_af=sum(crop_acft)) %>%
    dplyr::group_by(region) %>%
    dplyr::summarise(mean_2classes=mean(sum_af))
  
  # get sims TAF results 
  sims <- af_cover %>% filter(model=="sims")
  
  # join the sims sum for herb_semi and the mean value for herb_semi for the two regions
  sims_joined <- dplyr::left_join(dplyr::left_join(sims, sims_herb_semi, by="region"), mean_herb_semi, by="region")
  
  # subtract the herb_sumi total from the orignal value and add the mean for the two crops
  sims_est <- sims_joined %>% mutate(sum_af_est=(sum_af - sum_wetherb_semiag + mean_2classes))  %>% 
    select(c(model, region, sum_af_est)) %>% 
    rename(sum_af=sum_af_est)
  
  sims_wo_herb_semiag <- sims_joined %>% mutate(sum_af_est=(sum_af - sum_wetherb_semiag))  %>% 
    select(c(model, region, sum_af_est)) %>% 
    rename(sum_af=sum_af_est)
  
  sims_wo_herb_semiag$model <- "sims_wo_herb_semiag"
  
  # remove sims from af_crop_filter and add in the new estimated results
  af_cover_wo_sims <- af_cover %>% filter(!model=="sims")
  bind <- bind_rows(af_cover_wo_sims,  sims_est, sims_wo_herb_semiag)
  
  # get summary table (by making data untidy)
  dsa <- bind %>% filter(region=="dsa") %>% ungroup() %>% select(model, sum_af)
  legal <- bind %>% filter(region=="legal") %>% ungroup() %>% select(model, sum_af)
  
  j <- full_join(dsa, legal, by="model")
  colnames(j) <- c("Method", "DSA", "LEGAL")
  j
}
