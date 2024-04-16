M F
31c	30a
02f	24a
37h	58d
55e	31h
35h	02g
30f	33e
58b	36b
48d	38g
34b	35g
15c	37b



# hap1
# leaf:  high end DP cutoff 2*mean for each sample, QUAL >50 for both
# seed/pollen: low end 50x universally, high end 2*mean for each sample
# need to call snps separately otherwise everyone has the same QUAL


mom=30aFLD_hap1
dad=31cMLD_hap1
vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_hap1.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross/30aFLD_hap1.filt.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross/31cMLD_hap1.filt.vcf.gz

vcf_seed=/ohta2/meng.yuan/rumex/pollen_competition/vcf2/30aSD_hap1.pileup.vcf
vcf_pollen=/ohta2/meng.yuan/rumex/pollen_competition/vcf/31cPD_hap1.pileup.vcf
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross/30aSD_hap1.filt.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross/31cPD_hap1.filt.vcf.gz

vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/cross/corss1_31c_30a_hap1.vcf.gz

# extract and filter leaf parents
bcftools view -s ${mom} ${vcf_in} | bcftools filter -e \
'QUAL<50 && INFO/DP>42' --threads 20 -O z -o ${vcf_out_mom}
bcftools view -s ${dad} ${vcf_in} | bcftools filter -e \
'QUAL<50 && INFO/DP>42' --threads 20 -O z -o ${vcf_out_dad}

# filter seed and pollen
bcftools filter -e 'INFO/DP<50 && INFO/DP>154' ${vcf_seed} \
--threads 20 -O z -o ${vcf_out_seed}
bcftools filter -e 'INFO/DP<50 && INFO/DP>159' ${vcf_pollen} \
--threads 20 -O z -o ${vcf_out_pollen}

# merge samples for the cross
tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
tabix ${vcf_out_seed}
tabix ${vcf_out_pollen}
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_seed} ${vcf_out_pollen} \
--threads 20 | bgzip > ${vcf_out}

# use bcftools query to get the fields you need
# then do python scripts

# the filtering on DP and QUAL actually faild on the parents, need to go back and try again




# bcftools filter -e 'INFO/DP<5' ${vcf_in} -O z -o ${vcf_in_filt1} 
# bcftools view -s Alaska_21.1.8_F1,Dur_16.6.2_F1,Dur_4.13.7_F2,Port_11_F2,Uconn_15.12.12_F1,Dur_13.8.10_F3,Equ_E13.E3.1_F1,Port_7_F1,Chile_2.12_F1 ${vcf_renamed} |  bgzip > ${vcf_U}
