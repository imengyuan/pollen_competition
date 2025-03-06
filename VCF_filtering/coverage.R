library(dplyr)
setwd("/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/Manuscripts/pollen_competition")
pd <- read.table("PD_auto_coverage.txt", header = T)
mld <- read.table("MLD_auto_coverage.txt", header = T)
cov <- inner_join(pd, mld, by = "sample")
cov <- cov %>% mutate(DP_pollen = 2 * PD_coverage) %>% mutate(DP_leaf = 2 * MLD_coverage) 
cov$DP_pollen <- floor(cov$DP_pollen)
cov$DP_leaf <- floor(cov$DP_leaf)
# get cross id
id <- read.table("id_sample.txt", header = T)
cov <- inner_join(id, cov, by = "sample")

