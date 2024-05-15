


# leaf

#new
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap2_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/NC/pollenLD_hap2_cross1.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/pollenLD_31c_30a_hap2.vcf.gz
bcftools mpileup -a DP,AD -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -a GQ --threads 20 -mv -O z -o ${output}


# seed pollen
mom=30aFLD_hap2
dad=31cMLD_hap2
seed=30aSD_hap2
pollen=31cPD_hap2

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/pollenLD_31c_30a_hap2.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross/${mom}.filt.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross/${dad}.filt.vcf.gz

vcf_seed=/ohta2/meng.yuan/rumex/pollen_competition/vcf/${seed}.pileup.vcf.gz
vcf_pollen=/ohta2/meng.yuan/rumex/pollen_competition/vcf/${pollen}.pileup.vcf.gz
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross/${seed}.filt.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross/${pollen}.filt.vcf.gz

vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/cross/cross_31c_30a_hap2.vcf.gz

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<36 & GT="0/1" & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<36 & GT!="0/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}

# seed
bcftools filter -i 'FMT/DP>50 & FMT/DP<134' ${vcf_seed} \
--threads 20 -O z -o ${vcf_out_seed}
# pollen
bcftools filter -i 'FMT/DP>50 & FMT/DP<140' ${vcf_pollen} \
--threads 20 -O z -o ${vcf_out_pollen}

tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
tabix ${vcf_out_seed}
tabix ${vcf_out_pollen}

# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_pollen} ${vcf_out_seed} --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT:%AD]\n' > ${vcf_out}
