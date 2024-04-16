# evaluate mapping stats for SD and PD samples
# hap 1
out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_hap1
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap1
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleSD.txt)
do
qualimap bamqc -bam ${in}/${i}_hap1.sorted.rg.dedup.bam \
--java-mem-size=16G -outdir ${out}/${i}
done

out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_hap1
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap1
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/samplePD.txt)
do
qualimap bamqc -bam ${in}/${i}_hap1.sorted.rg.dedup.bam \
--java-mem-size=16G -outdir ${out}/${i}
done


# hap2
out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_hap2
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap2
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleSD.txt)
do
qualimap bamqc -bam ${in}/${i}_hap2.sorted.rg.dedup.bam \
--java-mem-size=16G -outdir ${out}/${i}
done

out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_hap2
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap2
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/samplePD.txt)
do
qualimap bamqc -bam ${in}/${i}_hap2.sorted.rg.dedup.bam \
--java-mem-size=16G -outdir ${out}/${i}
done


# evaluate mapping stats for LD samples
# hap 1
out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_hap1
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap1
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleLD.txt)
do
qualimap bamqc -bam ${in}/${i}_hap1.sorted.rg.dedup.bam \
--java-mem-size=16G -outdir ${out}/${i}
done

# hap2
out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_hap2
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap2
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleLD.txt)
do
qualimap bamqc -bam ${in}/${i}_hap2.sorted.rg.dedup.bam \
--java-mem-size=16G -outdir ${out}/${i}
done

     # mean coverageData = 100.3915X
     # std coverageData = 314.1187X # maybe separately
## get a summary of coverage
# check individual hmtl reports
cd /ohta2/meng.yuan/rumex/pollen_competition/bamqc_hap1
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/samplePD.txt)
do
#echo ${i}
grep 'mean coverageData' ${i}/genome_results.txt | cut -c 26-100 
done


out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_hap2
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap2
i=35gFLD 
qualimap bamqc -bam ${in}/${i}_hap2.sorted.rg.dedup.bam \
--java-mem-size=16G -outdir ${out}/${i}


hap1 
X, A4, A1, A2

hap2 
A4, Y2, A1, Y1, A2





















