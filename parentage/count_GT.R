setwd("/Users/yuanmeng/Library/CloudStorage/OneDrive-UniversityofToronto/Manuscripts/pollen_competition/parentage/")

args = commandArgs(trailingOnly=TRUE)
id <- paste0("cross", args[1], "_", args[3], "_", args[2])

GT1 <- read.table(paste0(id , "_GT1.vcf"))
GT2 <- read.table(paste0(id , "_GT2.vcf"))

# GT1
d1 <- as.data.frame(table(GT1$V5))
d1 <- t(d1)
colnames(d1) <- "ML1"

d2 <- as.data.frame(table(GT1$V7))
d2 <- t(d2)
colnames(d2) <- "FL1"

d3 <- as.data.frame(table(GT1$V9))
d3 <- t(d3)
colnames(d3) <- paste0("S1_", seq_len(ncol(d3)))

# GT2
d4 <- as.data.frame(table(GT2$V5))
d4 <- t(d4)
colnames(d4) <- "ML2"

d5 <- as.data.frame(table(GT2$V7))
d5 <- t(d5)
colnames(d5) <- "FL2"

d6 <- as.data.frame(table(GT2$V9))
d6 <- t(d6)
colnames(d6) <- paste0("S2_", seq_len(ncol(d6)))

all <- cbind(d1, d2, d3, d4, d5, d6)
write.table(all, file = paste0(id , "_GT_cnt.txt"), quote = F, row.names = F, sep = "\t")

