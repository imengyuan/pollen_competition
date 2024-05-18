# leaf, done
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/NC/pollenLD_hap1_test.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_AD.vcf.gz
bcftools mpileup -a DP,AD -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -a GQ --threads 20 -mv -O z -o ${output}


# trouble shoot
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/NC/pollenLD_hap1_test.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -a GQ --threads 20 -mv -O z -o ${output}




# seed and pollen
ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX/
out=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/
for i in "31cPD" "30aSD"
do
bcftools mpileup -a DP,AD -d 5000 -Ov -f ${ref} ${in}/${i}.sorted.rg.dedup.bam --threads 20 \
| bgzip > ${out}/${i}.pileup.vcf.gz
done


ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
in=/ohta2/meng.yuan/rumex/pollen_competition/NC/AnalysisReady_hap1/
out=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/
for i in "31cPD" "30aSD"
do
bcftools mpileup -a DP,AD -d 5000 -Ov -f ${ref} ${in}/${i}_hap1.sorted.rg.dedup.bam --threads 20 \
|  bgzip > ${out}/${i}_hap1.pileup.vcf.gz
done



# filter vcfs
# seed
vcf_seed=/ohta2/meng.yuan/rumex/pollen_competition/vcf2/30aSD_hap1.pileup.vcf.gz
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross/30aSD_hap1.filt2.vcf.gz
bcftools filter -i 'FMT/DP>50 & FMT/DP<154' ${vcf_seed} \
--threads 20 -O z -o ${vcf_out_seed}
#  PL:DP:ADF:ADR:AD        0,250,11:83:83,0:0,0:83,0

# pollen
vcf_pollen=/ohta2/meng.yuan/rumex/pollen_competition/vcf/31cPD_hap1.pileup.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross/31cPD_hap1.filt2.vcf.gz
bcftools filter -i 'FMT/DP>50 & FMT/DP<159' ${vcf_pollen} \
--threads 20 -O z -o ${vcf_out_pollen}
# PL:DP:ADF:ADR:AD        0,229,9:76:75,0:1,0:76,0

# mom
mom=30aFLD_hap1
vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_new.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross/30aFLD_hap1.filt2_new.vcf.gz
bcftools view -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}

# dad (test this too)
dad=31cMLD_hap1
vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross/31cMLD_hap1.filt2.vcf.gz
bcftools view -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT="0/1" & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}


# test works
# mom=30aFLD_hap1
# vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_new.vcf.gz
# vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross/30aFLD_hap1.filt2_new.vcf.gz
# bcftools view -s ${mom} ${vcf_in} | bcftools filter -i \
# 'GQ>50 & FMT/DP<42 & FMT/DP>0  & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}


# old hap1 with GQ
dad=31cMLD_hap1
vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_new.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross/31cMLD_hap1.filt2.vcf.gz
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT="0/1" & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}

mom=30aFLD_hap1
vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1_new.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross/30aFLD_hap1.filt2_new.vcf.gz
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT!="0/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}


# merge vcfs
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross/30aSD_hap1.filt2.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross/31cPD_hap1.filt2.vcf.gz
#vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross/30aFLD_hap1.filt2.vcf.gz
#vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross/31cMLD_hap1.filt2.vcf.gz
vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/cross/cross1_31c_30a_hap1_new.vcf.gz

tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
# tabix ${vcf_out_seed}
# tabix ${vcf_out_pollen}

# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_pollen} ${vcf_out_seed} --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT:%AD]\n' \
| bgzip > ${vcf_out}


# test

