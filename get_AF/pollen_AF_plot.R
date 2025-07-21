library(ggplot2)
library(dplyr)
library(data.table)
setwd("/ohta2/meng.yuan/rumex/pollen_competition/cross_TX")

args = commandArgs(trailingOnly=TRUE)
id <- paste0("cross", args[1], "_", args[2])
cross <- read.table(paste0(id,"_test.tmp"), header = T)
# test
#cross <- read.table("cross8_48d_test.tmp", header = T)
#cross <- dplyr::slice_sample(cross, prop = .1) 
cross <- as.data.table(cross)
cross$chrom <- factor(cross$chrom)
cross <- cross %>% filter(p_value < 1)

p <- ggplot(cross, aes(x = pos/1000000, y = -log10(p_value)))+geom_point(size = 0.3, alpha=0.3)+ facet_grid(.~chrom,scales="free_x", switch = "x", space = "free_x") + xlab("Position on chromosome (Mb)")+ylab("-log10(p value)")+ggtitle(paste0("Male ", args[1]))+theme_bw() + theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(), axis.ticks.x = element_blank(),panel.spacing = unit(0.1, "cm"),strip.background = element_blank(),strip.placement = "outside")+ theme(text = element_text(size = 11)) 

ggsave(p, filename = paste0(id,"_test.png"), device = "png", height = 3.36, width = 10, units = "in")
