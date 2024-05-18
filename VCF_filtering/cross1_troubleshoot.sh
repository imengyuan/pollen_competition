# trouble shoot
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/NC/pollenLD_hap1_test.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -a GQ --threads 20 -mv -O z -o ${output}


# all 40 samples for hap1
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/bam_hap1.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/hap1_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -f GQ --threads 20 -mv -O z -o ${output}


mom=30aFLD_hap1
dad=31cMLD_hap1
seed=30aSD_hap1
pollen=31cPD_hap1

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_GT.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/${mom}.filt.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/${dad}.filt.vcf.gz
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/${seed}.filt.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/${pollen}.filt.vcf.gz
vcf_out1=/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/cross1_31c_30a_hap1_GT1.vcf.gz
vcf_out2=/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/cross1_31c_30a_hap1_GT2.vcf.gz

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT="0/0" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT="1/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}

# seed
bcftools view -s ${seed} ${vcf_in} | bcftools filter -i 'FMT/DP>50 & FMT/DP<154'  \
--threads 20 -O z -o ${vcf_out_seed}
# pollen
bcftools view -s ${pollen} ${vcf_in} |bcftools filter -i 'FMT/DP>50 & FMT/DP<159' \
--threads 20 -O z -o ${vcf_out_pollen}

tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
tabix ${vcf_out_seed}
tabix ${vcf_out_pollen}

# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_pollen} ${vcf_out_seed} --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out1}

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT="1/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT="0/0" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}

tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_pollen} ${vcf_out_seed} --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out2}


sed -i 's/\:/\t/g' cross1_31c_30a_hap1_GT2.vcf


dad=31cMLD_hap1
vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_GT.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/${dad}.filt.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/${pollen}.filt.vcf.gz
vcf_out3=/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/cross1_31c_30a_hap1_pollen.vcf

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT="0/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
tabix ${vcf_out_dad}
# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_pollen}  --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out3}


/ohta2/meng.yuan/rumex/pollen_competition/cross1_GT/cross1_31c_30a_hap1_pollen.vcf

sed -i 's/\,/\t/g' cross1_31c_30a_hap1_pollen.vcf


