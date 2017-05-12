# makes a custom legend for the different groups colors
source("scripts/helper_functions.R")

# library
library(ggplot2)
library(grid)
library(gridExtra)

# create a dummy data frame to store names, models, dummy data to create a line plot
model_names <- c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT", "ETo")
models <- c("calsimetaw", "detaw", "disalexi", "itrc", "sims", "ucdmetric", "ucdpt", "eto")
dummy_data <- c(1:(length(models)*10))
model_df <-  data.frame(MODEL=models, NAMES=model_names, D=dummy_data)
model_df

# need to change the order of the models
model_df$MODEL <- factor(model_df$MODEL, levels=models)
  
# create a line plot using the dummy data
p <- ggplot(model_df, aes(x=NAMES, y=D, group=MODEL))+
  geom_line(aes(linetype=MODEL, color=MODEL),size=1.25)+
  scale_color_manual(values=model_palette, labels=model_names)+
  theme_bw()+
  scale_linetype_manual(values=model_lny, labels=model_names)+
  theme(legend.title=element_blank())+
  guides(fill = guide_legend(keywidth = 1, keyheight = 1),
           linetype=guide_legend(keywidth = 3, keyheight = 1),
           colour=guide_legend(keywidth = 3, keyheight = 1))
p

# modify the line plot so the legend is horizontal
horiz <- p + guides(colour = guide_legend(nrow = 1, keywidth = 3, keyheight = 1),fill = guide_legend(keywidth = 1, keyheight = 1),
                    linetype=guide_legend(keywidth = 3, keyheight = 1)) + theme(legend.position="bottom", # position of legend or none
  legend.direction="horizontal", # orientation of legend
  legend.title= element_blank()) # no title for legend

horiz

# Function to extract Legend from a ggplot object 
g_legend<-function(a.gplot){ 
  tmp <- ggplot_gtable(ggplot_build(a.gplot)) 
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
  legend <- tmp$grobs[[leg]] 
  return(legend)} 


# clear plots before running
# output pixel size is 162x210
vertical_legend <- g_legend(p)
grid.draw(vertical_legend)


# clear plots before running
# output pixel size is 900x100
horizontal_legend <- g_legend(horiz)
grid.draw(horizontal_legend)
