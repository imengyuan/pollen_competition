# cross2 02f	24a

# bam_cross7.txt
/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX/36bFLD.sorted.rg.dedup.bam
/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX/58bMLD.sorted.rg.dedup.bam
/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX/36bSD.sorted.rg.dedup.bam
/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX/58bPD.sorted.rg.dedup.bam


ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/bam_cross7.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/cross7_58b_36b_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -f GQ --threads 20 -mv -O z -o ${output}



# all 40 samples for  [pollen2]
ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/bam_TX.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/VCF_cross/TX_40samples_GT.vcf.gz
bcftools mpileup -a DP,AD -d 5000 -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call -f GQ --threads 20 -mv -O z -o ${output}

