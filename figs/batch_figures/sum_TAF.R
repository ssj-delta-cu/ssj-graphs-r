source("figs/batch_figures/output_settings.R")
source("scripts/tables.R")
fig_num <- 6

# make an ouput folder for the figure
mainDir <- getwd()
subDir <-paste("figs/fig", fig_num, sep="")
ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)


# loop through both water years and save the figure
for(y in 1:length(water_years)){
  wy <- water_years[y]
  
  p <- sum_TAFxModel_dsa_legal(dsa_legal_data, wy)
  
  # add footer
  p <- p + labs(caption=footer)
  
  # build name for export
  base <- paste("TAF_wy", wy, "_dsa_legal", ".png", sep='')
  name <- paste(file.path(mainDir, subDir), base, sep="/")
  
  # save
  ggsave(name, p, width=8, height=4, units="in")
  print(name)
  
  # let's also generate a table with this data and save as csv
  t <- table_taf_wy_regions(dsa_legal_data, wy)
  
  # build name for export
  base <- paste("TAF_wy", wy, "_dsa_legal", ".csv", sep='')
  name <- paste(file.path(mainDir, subDir), base, sep="/")
  
  write.csv(t, name)
  }


