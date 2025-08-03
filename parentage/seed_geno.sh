# check seed genotype when parents are homo for diffrent alleles
id="$1"
female="$2"
male="$3"
# DP threshold, 2*mean in the sample
DP_f="$4"
DP_m="$5"
DP_seed="$6"

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT.vcf.gz
vcf_mom=/ohta2/meng.yuan/rumex/pollen_competition/parentage/${female}FLD.filt.vcf.gz
vcf_dad=/ohta2/meng.yuan/rumex/pollen_competition/parentage/${male}MLD.filt.vcf.gz
vcf_seed=/ohta2/meng.yuan/rumex/pollen_competition/parentage/${female}SD.filt.vcf.gz

vcf_out1=/ohta2/meng.yuan/rumex/pollen_competition/parentage/cross${id}_${male}_${female}_GT1.vcf
vcf_out2=/ohta2/meng.yuan/rumex/pollen_competition/parentage/cross${id}_${male}_${female}_GT2.vcf


# seed
filter=$(printf 'FMT/DP>50 & FMT/DP<%d' "$DP_seed")
bcftools view -s "${female}SD" -r A1,A2,A3,A4 ${vcf_in} --threads 20 | \
bcftools filter -i "$filter" --threads 20 -O z -o ${vcf_seed}
tabix ${vcf_seed}

############### GT1 ###############
# mom
filter=$(printf 'GQ>50 & FMT/DP<%d & GT="1/1" & FMT/DP>0 & ALT !="."' "$DP_f")
bcftools view -m2 -M2 -s "${female}FLD" -r A1,A2,A3,A4 ${vcf_in} --threads 20 | \
bcftools filter -i "$filter" --threads 20 -O z -o ${vcf_mom}
tabix ${vcf_mom}

# dad
filter=$(printf 'GQ>50 & FMT/DP<%d & GT="0/0" & FMT/DP>0 & ALT !="."' "$DP_m")
bcftools view -m2 -M2 -s "${male}MLD" -r A1,A2,A3,A4 ${vcf_in} --threads 20 | \
bcftools filter -i "$filter" --threads 20 -O z -o ${vcf_dad}
tabix ${vcf_dad}

# merge  
bcftools merge ${vcf_dad} ${vcf_mom} ${vcf_seed} --threads 20 | \
bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out1}

############### GT2 ###############
# mom
filter=$(printf 'GQ>50 & FMT/DP<%d & GT="0/0" & FMT/DP>0 & ALT !="."' "$DP_f")
bcftools view -m2 -M2 -s "${female}FLD" -r A1,A2,A3,A4  ${vcf_in} --threads 20 | \
bcftools filter -i "$filter" --threads 20 -O z -o ${vcf_mom}
tabix ${vcf_mom}

# dad
filter=$(printf 'GQ>50 & FMT/DP<%d & GT="1/1" & FMT/DP>0 & ALT !="."' "$DP_m")
bcftools view -m2 -M2 -s "${male}MLD" -r A1,A2,A3,A4 ${vcf_in} --threads 20 | \
bcftools filter -i "$filter" --threads 20 -O z -o ${vcf_dad}
tabix ${vcf_dad}

# merge  
bcftools merge ${vcf_dad} ${vcf_mom} ${vcf_seed} --threads 20 | \
bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out2}

