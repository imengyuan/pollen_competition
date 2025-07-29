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
freq_cross <- freq_cross %>% filter(no_sites > 100)
freq_cross$chrom <- factor(freq_cross$chrom)

freq_long_cross <- gather(freq_cross, Category, freq, leaf_freq:pollen_freq, factor_key = TRUE)
levels(freq_long_cross$Category) <- c("Leaf", "Pollen")


# SNP density
p1 <- ggplot(freq_cross, aes(x = start/1000000, y = no_sites)) +
    geom_point(size = 0.3, alpha = 0.5, colour = "darkgrey") + 
    geom_smooth(colour = "black") +
    facet_grid(.~chrom, scales = "free_x", switch = "x", space = "free_x") + 
    xlab("") + ylab("Number of SNPs") + 
    ggtitle("a") + 
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          panel.spacing = unit(0.1, "cm"),
          strip.background = element_blank(), 
          strip.placement = "outside",
          text = element_text(size = 12))

# ref allele frequency
p2 <- ggplot(freq_long_cross, aes(x = start/1000000, y = freq)) +
    geom_point(aes(colour = Category), size = 0.3, alpha = 0.3) + 
    geom_smooth(aes(colour = Category)) + 
    facet_grid(.~chrom, scales = "free_x", switch = "x", space = "free_x") +  
    ggtitle("b") +
    xlab("") + 
    ylab("Ref allele freq") + 
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          panel.spacing = unit(0.1, "cm"),
          strip.background = element_blank(), 
          strip.placement = "outside",
          text = element_text(size = 12)) + 
    scale_colour_manual(values = c("#FF2400", "#0077ec"))

# MAF
freq_cross <- freq_cross %>% mutate(leaf_freq = ifelse(leaf_freq <= 0.5, leaf_freq, 1 - leaf_freq)) %>% mutate(pollen_freq = ifelse(pollen_freq <= 0.5, pollen_freq, 1 - pollen_freq)) 

freq_long_cross <- gather(freq_cross, Category, freq, leaf_freq:pollen_freq, factor_key = TRUE)
levels(freq_long_cross$Category) <- c("Leaf", "Pollen")

p3 <- ggplot(freq_long_cross, aes(x = start/1000000, y = freq)) +
    geom_point(aes(colour = Category), size = 0.3, alpha = 0.3) + 
    geom_smooth(aes(colour = Category)) + 
    facet_grid(.~chrom, scales = "free_x", switch = "x", space = "free_x") +  
    ggtitle("c") +
    xlab("") + 
    ylab("Minor allele freq") + 
    theme_bw() + 
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          panel.spacing = unit(0.1, "cm"),
          strip.background = element_blank(), 
          strip.placement = "outside",
          text = element_text(size = 12)) + 
    scale_colour_manual(values = c("#FF2400", "#0077ec"))


#  p values
cross <- read.table(paste0(id,"_sliding_p_avg.txt"), header = T)
cross <- as.data.table(cross)
cross$chrom <- factor(cross$chrom)

p4 <- ggplot(cross, aes(x = mid_pos / 1000000, y = -log10(p_value_avg))) + 
    geom_point(size = 0.3,alpha = 0.5,colour = "darkgrey") +
    geom_smooth(colour = "black") + 
    facet_grid(. ~ chrom,scales = "free_x",switch = "x",space = "free_x") + 
    ggtitle("d") + xlab("Position on chromosome (Mb)") +
    ylab("-log10(p-value)") + theme_bw() + theme(
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.spacing = unit(0.1, "cm"),
        strip.background = element_blank(),
        strip.placement = "outside",
        text = element_text(size = 12))

p <- p1 + plot_spacer() + p2 + plot_spacer() + p3 + plot_spacer() + p4 + plot_layout(ncol = 1, heights = c(5,-2.5,5,-2.5,5,-2.5,5), guides = "collect") & theme(legend.position = "right")

ggsave(p, filename = paste0(id,"_all_plots.png"), device = "png", height = 8, width = 10, units = "in")
#ggsave(p, filename = paste0(id,"_all_plots.pdf"), device = "pdf", height = 10, width = 10, units = "in")
