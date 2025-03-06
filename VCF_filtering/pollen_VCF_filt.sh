# extract ready-to-use VCF for each cross
# cross2 02f	24a
# maybe write a snakemake pipeline

# parse VCF
id=2
male=02f
# DP threshold, 2*mean in the sample
DP_leaf=38
DP_pollen=160

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



######################################################################
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


