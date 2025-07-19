# use qualimap bamqc to extract mean coverage from BAMs

out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_TX
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleSD.txt)
do
qualimap bamqc -bam ${in}/${i}.sorted.rg.dedup.bam \
--java-mem-size=16G -outdir ${out}/${i}
done

out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_TX
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/samplePD.txt)
do
qualimap bamqc -bam ${in}/${i}.sorted.rg.dedup.bam \
--java-mem-size=16G -outdir ${out}/${i}
done

# for a plot
out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_TX
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX
for i in "36bSD" "58bPD"
do
qualimap bamqc -bam ${in}/${i}.sorted.rg.dedup.bam -c \
/ohta2/meng.yuan/rumex/pollen_competition/chrom.bed \
--java-mem-size=16G -outdir ${out}/${i}
done


# try tinycov for a plot
out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_TX
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX
for i in "36bFLD" "58bMLD" "36bSD" "58bPD"
do
tinycov covplot ${in}/${i}.sorted.rg.dedup.bam \
--out ${out}/${i}.pdf -s 1000 -r 1000000 --whitelist A1,A2,A3,A4,Y,X
done




## get a summary of coverage from bamqc output
# PD and MLD
cd /ohta2/meng.yuan/rumex/pollen_competition/bamqc_TX

output_file="PD_auto_coverage.txt" 
echo -e "sample\t_coverage" > $output_file 

for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/samplePD.txt)
do
file=${i}/genome_results.txt
num=$(awk '{sum1+=$2; sum2+=$3} END {print sum2/sum1}' <(grep 'A1' ${file}; grep 'A2' ${file}; grep 'A3' ${file}; grep 'A4' ${file}))
echo -e "${i}\t${num}" >> $output_file
done



output_file="MLD_auto_coverage.txt" 
echo -e "sample\t_coverage" > $output_file 
 
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleMLD.txt)
do
file=${i}/genome_results.txt
num=$(awk '{sum1+=$2; sum2+=$3} END {print sum2/sum1}' <(grep 'A1' ${file}; grep 'A2' ${file}; grep 'A3' ${file}; grep 'A4' ${file}))
echo -e "${i}\t${num}" >> $output_file
done


