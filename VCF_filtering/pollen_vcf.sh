id="$1"
male="$2"
# DP threshold, 2*mean in the sample
DP_leaf="$4"
DP_pollen="$3"

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT.vcf.gz
vcf_leaf=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${male}MLD.filt.vcf.gz
vcf_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${male}PD.filt.vcf.gz
vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross${id}_${male}_pollen.vcf

# leaf
filter=$(printf 'GQ>50 & FMT/DP<%d & GT="0/1" & FMT/DP>0 & ALT !="."' "$DP_leaf")
bcftools view -m2 -M2 -s "${male}MLD" ${vcf_in} | bcftools filter -i "$filter" --threads 20 -O z -o ${vcf_leaf}

# pollen
filter=$(printf 'FMT/DP>50 & FMT/DP<%d' "$DP_pollen")
bcftools view -s "${male}PD" ${vcf_in} | bcftools filter -i "$filter" --threads 20 -O z -o ${vcf_pollen}

# index new VCFs
tabix ${vcf_leaf}
tabix ${vcf_pollen}

# merge VCFs
bcftools merge ${vcf_leaf} ${vcf_pollen}  --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out}

