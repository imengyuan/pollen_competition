library(dplyr)
library(data.table)
library(stringr)
setwd("/ohta2/meng.yuan/rumex/pollen_competition/cross_TX")
args = commandArgs(trailingOnly=TRUE)
id <- paste0("cross", args[1], "_", args[2])

fisher_test <- function(dad0, dad1, pollen0, pollen1) {
    values <- c(dad0, dad1, pollen0, pollen1)
    contingency_table <- matrix(values, nrow = 2, byrow = TRUE)
    test_result <- fisher.test(contingency_table)
    odds_ratio <- test_result$estimate
    p_value <- test_result$p.value
    return(list(odds_ratio = odds_ratio, p_value = p_value))
}

cross <- read.table(paste0(id,"_pollen.filt.vcf"))
colnames(cross) <- c("chrom", "pos", "ref", "alt", "dad", "dad0", "dad1", "pollen", "pollen0", "pollen1")
cross <- cross %>% filter(str_starts(chrom, "A"))

# remove problematic sites from leaf
cross <- cross %>% mutate(leaf_raf = dad0 / (dad0 + dad1))
cross <- cross %>% filter(leaf_raf >= 0.45 & leaf_raf <= 0.55)

cross <- as.data.table(cross)
cross[, c("odds_ratio", "p_value") := fisher_test(dad0, dad1, pollen0, pollen1), by = 1:nrow(cross)]
write.table(cross, file=paste0(id,"_test.txt"), quote = F, row.names = F,sep = "\t")
