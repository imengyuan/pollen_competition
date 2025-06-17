# all 40 samples
ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/bam_TX.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -f GQ --threads 20 -mv -O z -o ${output}

