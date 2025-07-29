
# filter for SNPs
vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT.vcf.gz
vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT.filt.vcf.gz


gunzip ${vcf_in} 
bgzip TX_40samples_GT.vcf 
tabix ${vcf_in}

vcftools --gzvcf ${vcf_in} \
--mac 1 \
--remove-indels \
--max-missing 1 \
--min-alleles 2 --max-alleles 2 \
--minQ 30 \
--min-meanDP 10 \
--max-meanDP 200 \
--recode --stdout | bgzip -c > ${vcf_out}

tabix ${vcf_out}

# keep only autosomes and also rename chroms
ln -s /ohta2/meng.yuan/rumex/eqtl/VCF/chr_names ./

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT.filt.vcf.gz
vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT_auto.filt.vcf.gz

bcftools view -r A1,A2,A3,A4 ${vcf_in} | \
bcftools annotate --rename-chrs chr_names | bgzip -c > ${vcf_out}


# plink
VCF=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT_auto.filt.vcf.gz

# make bed file
i=TX_40samples
plink --vcf $VCF --double-id --allow-extra-chr  \
--keep-allele-order --set-missing-var-ids @:# \
--maf 0.05 --hwe 1e-6 \
--biallelic-only strict \
--make-bed --out ${i}
# 54302950 variants loaded from .bim file.
# --hwe: 299912 variants removed due to Hardy-Weinberg exact test.
# 21672707 variants removed due to minor allele threshold(s)
# 32330331 variants and 40 people pass filters and QC.


# LD pruning
plink --bfile ${i} --indep-pairwise 200 50 0.1 \
--allow-extra-chr --keep-allele-order --out ${i}_ld
# Pruned 13456885 variants from chromosome 1, leaving 212455.
# Pruned 8787679 variants from chromosome 2, leaving 152015.
# Pruned 5107618 variants from chromosome 3, leaving 98894.
# Pruned 4443238 variants from chromosome 4, leaving 71547.
# Pruning complete.  31795420 of 32330331 variants removed.


# pca using plink
plink --bfile ${i} --double-id --allow-extra-chr --set-missing-var-ids @:# \
--extract ${i}_ld.prune.in --pca --out ${i}_ld
# 534911 variants and 40 people pass filters and QC.


# get LD pruned files
plink --bfile ${i} --extract ${i}_ld.prune.in \
--allow-extra-chr --keep-allele-order --make-bed --out ${i}_ld
# 534911 variants and 40 people pass filters and QC.

# related matrix 
plink --bfile ${i}_ld --make-rel triangle --out ${i}_grm 

plink --bfile ${i}_ld -make-grm-gz no-gz --out ${i}_grm


