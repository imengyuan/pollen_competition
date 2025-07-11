library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)
library(data.table)
data <- "/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/Manuscripts/pollen_competition/"
setwd("/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/Manuscripts/pollen_competition/")

args = commandArgs(trailingOnly=TRUE)
id <- paste0("cross", args[1], "_", args[2])


freq_cross <- read.table(paste0(data, id , "_pollen.vcf.freq"))
colnames(freq_cross) <- c("chrom", "start", "end", "no_sites", "leaf_freq", "pollen_freq")
freq_cross <- freq_cross %>% mutate(leaf_freq = ifelse(leaf_freq <= 0.5, leaf_freq, 1 - leaf_freq)) %>% mutate(pollen_freq = ifelse(pollen_freq <= 0.5, pollen_freq, 1 - pollen_freq)) 

freq_cross <- freq_cross %>% filter(no_sites > 100)
freq_cross$chrom <- factor(freq_cross$chrom)

# prepare for plots
freq_long_cross <- gather(freq_cross, Category, freq, leaf_freq:pollen_freq, factor_key = TRUE)
levels(freq_long_cross$Category) <- c("Leaf", "Pollen")

# SNP density
p1 <- ggplot(freq_cross, aes(x = start/1000000, y = no_sites)) +
    geom_point(size = 0.3, alpha = 0.8, colour = "darkgrey") + 
    geom_smooth(colour = "black") +
    facet_grid(.~chrom, scales = "free_x", switch = "x", space = "free_x") + 
    xlab("") + ylab("Number of SNPs") + 
    ggtitle(paste0("Male ", args[1])) + 
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          axis.ticks.x = element_blank(), 
          panel.spacing = unit(0.1, "cm"),
          strip.background = element_blank(), 
          strip.placement = "outside",
          text = element_text(size = 11))

# allele frequency
p2 <- ggplot(freq_long_cross, aes(x = start/1000000, y = freq)) +
    geom_point(aes(colour = Category), size = 0.3, alpha = 0.3) + 
    geom_smooth(aes(colour = Category)) + 
    facet_grid(.~chrom, scales = "free_x", switch = "x", space = "free_x") +  
    xlab("") + 
    ylab("MAF") + 
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          axis.ticks.x = element_blank(), 
          panel.spacing = unit(0.1, "cm"),
          strip.background = element_blank(), 
          strip.placement = "outside",
          text = element_text(size = 11))



cross <- read.table(paste0(id,"_sliding_p_avg.txt"), header = T)
cross <- as.data.table(cross)
cross$chrom <- factor(cross$chrom)

p3 <- ggplot(cross, aes(x = mid_pos/1000000, y = -log10(p_value_avg)))+geom_point(size = 0.3, alpha=0.3)+geom_smooth()+ facet_grid(.~chrom,scales="free_x", switch = "x", space = "free_x") + xlab("Position on chromosome (Mb)")+ylab("-log10(p value)")+theme_bw() + theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(), axis.ticks.x = element_blank(),panel.spacing = unit(0.1, "cm"),strip.background = element_blank(),strip.placement = "outside")+ theme(text = element_text(size = 11)) 

p <- p1 + p2 + p3 + plot_layout(nrow = 3, byrow = FALSE)

ggsave(p, filename = paste0(id,"all_plots.png"), device = "png", height = 7.5, width = 10, units = "in")
