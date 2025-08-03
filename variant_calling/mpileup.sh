# generate pileup file
ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX/
out=/ohta2/meng.yuan/rumex/pollen_competition/pileup/
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/samplePD.txt)
do
bcftools mpileup  -B -I -a AD,DP -d 5000 -Oz -f ${ref} ${in}/${i}.sorted.rg.dedup.bam --threads 25 \
 > ${out}/${i}.pileup.vcf.gz
done


# index all pileup.vcf
out=/ohta2/meng.yuan/rumex/pollen_competition/pileup/
cat /ohta2/meng.yuan/rumex/pollen_competition/samplePD.txt | \
parallel -j 10 "tabix ${out}/{}.pileup.vcf.gz"


# remove multi-allelic sites in pollen where AF of 3rd and 4th allele > 5%
vi filt_multi_allelic.sh
chmod +x filt_multi_allelic.sh

cat pollen_auto_cov.txt | awk '{print $1, $2}' | parallel -j 20 --colsep ' ' ./filt_multi_allelic.sh {1} {2}


# rm or zip ${vcf_out}, not needed
cd /ohta2/meng.yuan/rumex/pollen_competition/pileup/
ls *_merged.filt.vcf
rm *_merged.filt.vcf
