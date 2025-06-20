# [pollen5]
# "02gFLD" "35hMLD" "02gSD" "35hPD"
# "36bFLD" "58bMLD" "36bSD" "58bPD"
ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX/
out=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/samplePD2.txt)
do
bcftools mpileup -a DP,AD -d 5000 -Ov -f ${ref} ${in}/${i}.sorted.rg.dedup.bam --threads 20 \
| bgzip > ${out}/${i}.pileup.vcf.gz
done

in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX/
out=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleSD2.txt)
do
bcftools mpileup -a DP,AD -d 5000 -Ov -f ${ref} ${in}/${i}.sorted.rg.dedup.bam --threads 20 \
| bgzip > ${out}/${i}.pileup.vcf.gz
done



# all 40 samples for  [pollen2]
ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/bam_TX.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -f GQ --threads 20 -mv -O z -o ${output}



# [pollen3]
# cross 5 "02gFLD" "35hMLD" "02gSD" "35hPD"
ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/bam_cross5.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/cross5_35h_02g_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -f GQ --threads 20 -mv -O z -o ${output}

# fake DP cutoff for now
# parse VCF
mom=02gFLD
dad=35hMLD
seed=02gSD
pollen=35hPD

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/cross5_35h_02g_GT.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${mom}.filt.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${dad}.filt.vcf.gz
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${seed}.filt.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${pollen}.filt.vcf.gz
vcf_out1=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross5_35h_02g_GT1.vcf
vcf_out2=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross5_35h_02g_GT2.vcf
vcf_out3=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross5_35h_02g_pollen.vcf

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<50 & GT="0/0" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<50 & GT="1/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}
# seed
bcftools view -s ${seed} ${vcf_in} | bcftools filter -i 'FMT/DP>50 & FMT/DP<200'  \
--threads 20 -O z -o ${vcf_out_seed}
# pollen
bcftools view -s ${pollen} ${vcf_in} |bcftools filter -i 'FMT/DP>50 & FMT/DP<200' \
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
'GQ>50 & FMT/DP<50 & GT="1/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<50 & GT="0/0" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}
tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_pollen} ${vcf_out_seed} --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out2}

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT="0/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
tabix ${vcf_out_dad}
# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_pollen}  --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out3}

sed -i 's/\,/\t/g' cross5_35h_02g_pollen.vcf



grep "A1" cross5_35h_02g_pollen.vcf > cross5_35h_02g_pollen_A1.vcf
grep "A2" cross5_35h_02g_pollen.vcf > cross5_35h_02g_pollen_A2.vcf
grep "A3" cross5_35h_02g_pollen.vcf > cross5_35h_02g_pollen_A3.vcf
grep "A4" cross5_35h_02g_pollen.vcf > cross5_35h_02g_pollen_A4.vcf
grep "X" cross5_35h_02g_pollen.vcf > cross5_35h_02g_pollen_X.vcf
grep "Y" cross5_35h_02g_pollen.vcf > cross5_35h_02g_pollen_Y.vcf

head -n 1 *.vcf

python3  get_AF_pollen.py cross5_35h_02g_pollen_A1.vcf A1 74101
python3  get_AF_pollen.py cross5_35h_02g_pollen_A2.vcf A2 14628
python3  get_AF_pollen.py cross5_35h_02g_pollen_A3.vcf A3 15566
python3  get_AF_pollen.py cross5_35h_02g_pollen_A4.vcf A4 15402
python3  get_AF_pollen.py cross5_35h_02g_pollen_X.vcf X 768
python3  get_AF_pollen.py cross5_35h_02g_pollen_Y.vcf Y 24733




# [pollen4]
# cross7 "36bFLD" "58bMLD" "36bSD" "58bPD"
ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/bam_cross7.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/cross_58b_36b_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -f GQ --threads 20 -mv -O z -o ${output}



# parse VCF
mom=36bFLD
dad=58bMLD
seed=36bSD
pollen=58bPD

vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/cross7_58b_36b_GT.vcf.gz
vcf_out_mom=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${mom}.filt.vcf.gz
vcf_out_dad=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${dad}.filt.vcf.gz
vcf_out_seed=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${seed}.filt.vcf.gz
vcf_out_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${pollen}.filt.vcf.gz
vcf_out1=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross7_58b_36b_GT1.vcf
vcf_out2=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross7_58b_36b_GT2.vcf
vcf_out3=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross7_58b_36b_pollen.vcf

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<50 & GT="0/0" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<50 & GT="1/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}
# seed
bcftools view -s ${seed} ${vcf_in} | bcftools filter -i 'FMT/DP>50 & FMT/DP<200'  \
--threads 20 -O z -o ${vcf_out_seed}
# pollen
bcftools view -s ${pollen} ${vcf_in} |bcftools filter -i 'FMT/DP>50 & FMT/DP<200' \
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
'GQ>50 & FMT/DP<50 & GT="1/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
# mom
bcftools view -m2 -M2 -s ${mom} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<50 & GT="0/0" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_mom}
tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_pollen} ${vcf_out_seed} --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out2}

# dad
bcftools view -m2 -M2 -s ${dad} ${vcf_in} | bcftools filter -i \
'GQ>50 & FMT/DP<42 & GT="0/1" & FMT/DP>0 & ALT !="."' --threads 20 -O z -o ${vcf_out_dad}
tabix ${vcf_out_dad}
# new merged  
bcftools merge ${vcf_out_dad} ${vcf_out_pollen}  --threads 20 \
| bcftools filter -e 'FMT/DP="."' | bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out3}

sed -i 's/\,/\t/g' ${vcf_out3}


grep "A1" cross7_58b_36b_pollen.vcf > cross7_58b_36b_pollen_A1.vcf
grep "A2" cross7_58b_36b_pollen.vcf > cross7_58b_36b_pollen_A2.vcf
grep "A3" cross7_58b_36b_pollen.vcf > cross7_58b_36b_pollen_A3.vcf
grep "A4" cross7_58b_36b_pollen.vcf > cross7_58b_36b_pollen_A4.vcf
grep "X" cross7_58b_36b_pollen.vcf > cross7_58b_36b_pollen_X.vcf
grep "Y" cross7_58b_36b_pollen.vcf > cross7_58b_36b_pollen_Y.vcf

head -n 1 *.vcf

python3  get_AF_pollen.py cross7_58b_36b_pollen_A1.vcf A1 24533
python3  get_AF_pollen.py cross7_58b_36b_pollen_A2.vcf A2 13776
python3  get_AF_pollen.py cross7_58b_36b_pollen_A3.vcf A3 15085
python3  get_AF_pollen.py cross7_58b_36b_pollen_A4.vcf A4 7557
python3  get_AF_pollen.py cross7_58b_36b_pollen_X.vcf X 839
python3  get_AF_pollen.py cross7_58b_36b_pollen_Y.vcf Y 5283





