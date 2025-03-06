# extract ready-to-use VCF for each cross
# cross2 02f	24a
# maybe write a snakemake pipeline

# parse VCF
id=2
dad=02f
# DP threshold, 2*mean in the sample
DP_dad=
DP_pollen= 

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT.vcf.gz
vcf_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${dad}MLD.filt.vcf.gz
vcf_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${dad}PD.filt.vcf.gz
vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross${id}_${dad}_pollen.vcf

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<${DP_dad} & GT="0/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_dad}
# pollen
bcftools view -s ${pollen} ${vcf_in} |bcftools filter -i 'FMT/DP>50 & FMT/DP<${DP_pollen}' \
--threads 20 -O z -o ${vcf_pollen}

# index new VCFs
tabix ${vcf_out_dad}
tabix ${vcf_out_pollen}

# merge VCFs
bcftools merge ${vcf_out_dad} ${vcf_out_pollen}  --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out}


# make separate VCF of each chrom for windowed analyses
id=2
dad=02f
for i in "A1" "A2" "A3" "A4" "X" "Y"
do
grep ${i} cross${id}_${dad}_pollen.vcf > cross${id}_${dad}_pollen_${i}.vcf
# get the sliding window start position for each chrom
start_pos=$(head -n 1 cross${id}_${dad}_pollen_${i}.vcf | cut -f2)

python3  get_AF_pollen.py cross${id}_${dad}_pollen_${i}.vcf ${i} ${start_pos} 
done

cat cross${id}_${dad}_pollen_*.vcf.freq > cross${id}_${dad}_pollen.vcf.freq


