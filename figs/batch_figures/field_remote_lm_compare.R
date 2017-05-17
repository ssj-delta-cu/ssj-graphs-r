# export field by remote sensing comparison
source("figs/batch_figures/output_settings.R")

fig_num <- 5

# make an ouput folder for the figure
mainDir <- getwd()
subDir <-paste("figs/fig", fig_num, sep="")
ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)


# facet version

p <- lm_fieldxremote_facet_crop(fieldstations_data)
# add footer
p <- p + labs(caption=footer)
p

# build name for export
base <- paste("Field_vs_Model_facet_crops", ".png", sep='')
name <- paste(file.path(mainDir, subDir), base, sep="/")

# save
ggsave(name, p, width=11, height=5, units="in")
print(name)

######################################################################
# 
# p1 <- lm_fieldxremote_crop(fieldstations_data, "pasture")
# p1
# 
# base <- paste("Field_vs_Model_pasture", ".png", sep='')
# name <- paste(file.path(mainDir, subDir), base, sep="/")
# 
# # save
# ggsave(name, p1, width=5, height=5, units="in")
# print(name)
