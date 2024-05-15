
# cross 5

35h	02g
# deed pollen
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
in=/ohta2/meng.yuan/rumex/pollen_competition/NC/AnalysisReady_hap1
out=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross
for i in "02gSD" "35hPD"
do
bcftools mpileup -a AD,DP -d 5000 -Ov -f ${ref} ${in}/${i}_hap1.sorted.rg.dedup.bam --threads 20 \
 |bgzip > ${out}/${i}_hap1.pileup.vcf.gz
done



# leaf
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/NC/pollenLD_hap1_cross5.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/pollenLD_35h_02g_hap1.vcf.gz
bcftools mpileup -a DP,AD -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -a GQ --threads 20 -mv -O z -o ${output}



# parse VCF
mom=02gFLD_hap1
dad=35hMLD_hap1
seed=02gSD_hap1
pollen=35hPD_hap1

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/pollenLD_35h_02g_hap1.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross5/${mom}.filt.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross5/${dad}.filt.vcf.gz

vcf_seed=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/${seed}.pileup.vcf.gz
vcf_pollen=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/${pollen}.pileup.vcf.gz
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross5/${seed}.filt.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross5/${pollen}.filt.vcf.gz

vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/cross5/cross5_35h_02g_hap1.vcf.gz

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<45 & GT="0/1" & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<46 & GT!="0/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}

# seed
bcftools filter -i 'FMT/DP>50 & FMT/DP<200' ${vcf_seed} \
--threads 20 -O z -o ${vcf_out_seed}
# pollen
bcftools filter -i 'FMT/DP>50 & FMT/DP<162' ${vcf_pollen} \
--threads 20 -O z -o ${vcf_out_pollen}

tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
tabix ${vcf_out_seed}
tabix ${vcf_out_pollen}

# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_pollen} ${vcf_out_seed} --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT:%AD]\n' > ${vcf_out}


# trouble shoot
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/NC/pollenLD_hap1_test.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -a GQ --threads 20 -mv -O z -o ${output}



