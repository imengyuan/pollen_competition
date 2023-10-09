# FLD + MLD call SNP, ploidy=2
# hap1 
ls /ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap1/*LD*.sorted.rg.dedup.bam>pollenLD_hap1.txt
ls /ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap1/*SD*.sorted.rg.dedup.bam>pollenSD_hap1.txt
ls /ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap1/*PD*.sorted.rg.dedup.bam>pollenPD_hap1.txt


ref=/ohta2/meng.yuan/rumex/pollen_competition/genome/NChap1_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/pollenLD_hap1.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_hap1.vcf.gz
bcftools mpileup -B -I -f ${ref} -b ${bamlist} --threads 20 \
| bcftools call --threads 20 -m -O z -o ${output}


# hap2
ls /ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap2/*LD*.sorted.rg.dedup.bam>pollenLD_hap2.txt
ls /ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap2/*SD*.sorted.rg.dedup.bam>pollenSD_hap2.txt
ls /ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap2/*PD*.sorted.rg.dedup.bam>pollenPD_hap2.txt

ref=/ohta2/meng.yuan/rumex/pollen_competition/genome/NChap2_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/pollenLD_hap2.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_hap2.vcf.gz
bcftools mpileup -B -I -f ${ref} -b ${bamlist} --threads 10 \
| bcftools call --threads 10 -m -O z -o ${output}



# get pileup file for SD, PD files
# SD
ref=/ohta2/meng.yuan/rumex/pollen_competition/genome/NChap1_final.fa
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap1/
out=/ohta2/meng.yuan/rumex/pollen_competition/vcf2/
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleSD.txt)
do
bcftools mpileup -a AD,DP,ADF,ADR -d 5000 -Ov -f ${ref} ${in}/${i}_hap1.sorted.rg.dedup.bam --threads 15 \
 > ${out}/${i}_hap1.pileup.vcf
done

# PD
ref=/ohta2/meng.yuan/rumex/pollen_competition/genome/NChap1_final.fa
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap1/
out=/ohta2/meng.yuan/rumex/pollen_competition/vcf/
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/samplePD.txt)
do
bcftools mpileup -a AD,DP,ADF,ADR -Ov -f ${ref} ${in}/${i}_hap1.sorted.rg.dedup.bam --threads 20 \
 > ${out}/${i}_hap1.pileup.vcf
done



# hap2




# samtools view -c 34bPD_hap2.sorted.rg.dedup.bam
# 989755435