library(ggplot2)
library(dplyr)
library(stringr)
library(patchwork)
data <- "/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/Manuscripts/pollen_competition/"
setwd("/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/Manuscripts/pollen_competition/")

args = commandArgs(trailingOnly=TRUE)
id <- paste0("cross", args[1], "_", args[2])

freq_cross <- read.table(paste0(data, id, "_pollen.vcf"))
colnames(freq_cross) <- c("chrom", "pos", "ref", "alt", "dad", "dad0", "dad1", "pollen", "pollen0", "pollen1")
freq_cross <- freq_cross %>% filter(str_starts(chrom, "A"))
freq_cross <- freq_cross %>% mutate(pollen_raf = pollen0 / (pollen0 + pollen1)) %>% mutate(leaf_raf = dad0 / (dad0 + dad1))
freq_cross <- freq_cross %>% mutate(pollen_maf = ifelse(pollen_raf <= 0.5, pollen_raf, 1 - pollen_raf)) %>% mutate(leaf_maf = ifelse(leaf_raf <= 0.5, leaf_raf, 1 - leaf_raf)) 

# pollen
p<-ggplot(freq_cross, aes(x=pollen_raf)) + geom_histogram(binwidth=0.01) 
p_data <- ggplot_build(p)$data[[1]]
p_data$y_prop <- p_data$y/sum(p_data$y) 

p1 <- ggplot(p_data, aes(x=x, y=y_prop)) +
    geom_bar(stat="identity", width = 0.01, color="white")  + theme_classic() + ggtitle("pollen RAF")+ labs(x="RAF", y="Proportion")+ theme(text = element_text(size = 10))  + expand_limits(x=1) + ylim(0,0.13)

p<-ggplot(freq_cross, aes(x=pollen_maf)) + geom_histogram(binwidth=0.01) 
p_data <- ggplot_build(p)$data[[1]]
p_data$y_prop <- p_data$y/sum(p_data$y) 

p2 <- ggplot(p_data, aes(x=x, y=y_prop)) +
    geom_bar(stat="identity", width = 0.01, color="white")  + theme_classic() + ggtitle("pollen MAF")+ labs(x="MAF", y="Proportion")+ theme(text = element_text(size = 10)) + expand_limits(x=0.5) + ylim(0,0.13)


# leaf
p<-ggplot(freq_cross, aes(x=leaf_raf)) + geom_histogram(binwidth=0.01) 
p_data <- ggplot_build(p)$data[[1]]
p_data$y_prop <- p_data$y/sum(p_data$y) 

p3 <- ggplot(p_data, aes(x=x, y=y_prop)) +
    geom_bar(stat="identity", width = 0.01, color="white")  + theme_classic() + ggtitle("leaf RAF")+ labs(x="RAF", y="Proportion")+ theme(text = element_text(size = 10))  + expand_limits(x=1) + ylim(0,0.13)

p<-ggplot(freq_cross, aes(x=leaf_maf)) + geom_histogram(binwidth=0.01) 
p_data <- ggplot_build(p)$data[[1]]
p_data$y_prop <- p_data$y/sum(p_data$y) 

p4 <- ggplot(p_data, aes(x=x, y=y_prop)) +
    geom_bar(stat="identity", width = 0.01, color="white")  + theme_classic() + ggtitle("leaf MAF")+ labs(x="MAF", y="Proportion")+ theme(text = element_text(size = 10)) + expand_limits(x=0.5) + ylim(0,0.13)

p <- p1 + p2 + p3 + p4 + plot_layout(ncol = 2, widths = c(2,1))
ggsave(p, filename = paste0(data, "leaf_pollen", args[1],"_ref_maf.png"), device = "png", height = 5, width = 6, units = "in")
