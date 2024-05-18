58b	36b

# cross 7

# seed pollen
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
in=/ohta2/meng.yuan/rumex/pollen_competition/NC/AnalysisReady_hap1
out=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross
for i in "36bSD" "58bPD"
do
bcftools mpileup -a AD,DP -d 5000 -Ov -f ${ref} ${in}/${i}_hap1.sorted.rg.dedup.bam --threads 20 \
 |bgzip > ${out}/${i}_hap1.pileup.vcf.gz
done


# leaf
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/NC/pollenLD_hap1_cross7.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/pollenLD_58b_36b_hap1.vcf.gz
bcftools mpileup -a DP,AD -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -a GQ --threads 20 -mv -O z -o ${output}


# parse VCF
mom=36bFLD_hap1
dad=58bMLD_hap1
seed=36bSD_hap1
pollen=58bPD_hap1

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/pollenLD_58b_36b_hap1.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross7/${mom}.filt.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross7/${dad}.filt.vcf.gz

vcf_seed=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/${seed}.pileup.vcf.gz
vcf_pollen=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/${pollen}.pileup.vcf.gz
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross7/${seed}.filt.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross7/${pollen}.filt.vcf.gz

vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/cross7/cross5_58b_36b_hap1.vcf.gz

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<57 & GT="0/1" & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<57 & GT!="0/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}

# seed
bcftools filter -i 'FMT/DP>50 & FMT/DP<144' ${vcf_seed} \
--threads 20 -O z -o ${vcf_out_seed}
# pollen
bcftools filter -i 'FMT/DP>50 & FMT/DP<203' ${vcf_pollen} \
--threads 20 -O z -o ${vcf_out_pollen}

tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
tabix ${vcf_out_seed}
tabix ${vcf_out_pollen}

# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_pollen} ${vcf_out_seed} --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT:%AD]\n' > ${vcf_out}
