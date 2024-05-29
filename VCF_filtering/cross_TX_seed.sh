mom=02gFLD
seed=02gSD

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/cross5_35h_02g_GT.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${mom}.filt.vcf.gz
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${seed}.filt.vcf.gz
vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross5_35h_02g_seed.vcf

# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<50 & GT="0/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}
tabix ${vcf_out_mom}

# new merged  
bcftools merge ${vcf_out_mom} ${vcf_out_seed} --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out}


sed -i 's/\,/\t/g' ${vcf_out}
