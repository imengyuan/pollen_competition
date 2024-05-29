bwa-mem2 index NChap1_final.fa

ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
parent_dir=/ohta2/meng.yuan/rumex/pollen_competition/fastq_merged
out_dir=/ohta2/meng.yuan/rumex/pollen_competition/BAM_TX

cat /ohta2/meng.yuan/rumex/pollen_competition/sampleAll.txt | parallel -j 30 'bwa-mem2 mem -t 1 ${ref} ${parent_dir}/{}_R1.fastq.gz ${parent_dir}/{}_R2.fastq.gz | samtools view -S -b -o ${out_dir}/{}_bwa.bam -' > bwa.out.txt



ref=/ohta2/meng.yuan/rumex/pollen_competition/genomeTX/merged_TX_noMatPAR.fa
parent_dir=/ohta2/meng.yuan/rumex/pollen_competition/fastq_merged
out_dir=/ohta2/meng.yuan/rumex/pollen_competition/BAM_TX
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleAll.txt)
do
bwa-mem2 mem -t 30 ${ref} ${parent_dir}/${i}_R1.fastq.gz ${parent_dir}/${i}_R2.fastq.gz | samtools view -S -b -o ${out_dir}/${i}_bwa.bam -
done




15cPD_bwa.bam
35hMLD_bwa.bam

7 PD needs picard

picard_SD_TX.sh Input bam file must be sorted by coordinate



# "02gFLD" "35hMLD" "02gSD" "35hPD"
# "36bFLD" "58bMLD" "36bSD" "58bPD"
# sampleSD.txt
out=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX
in=/ohta2/meng.yuan/rumex/pollen_competition/BAM_TX
picard=/ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar
for i in 
do
# after getting bwa.bam, sort bam
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar $picard SortSam \
      I=${in}/${i}_bwa.bam \
      O=${out}/${i}.sorted.bam \
      SORT_ORDER=coordinate

# add read group
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar $picard AddOrReplaceReadGroups \
       INPUT=${out}/${i}.sorted.bam \
       OUTPUT=${out}/${i}.sorted.rg.bam \
       RGID=${i}_id \
       RGLB=rumex \
       RGPL=Illumina \
       RGPU=unit1 \
       RGSM=${i} \
       >> ${out}/rg2.out 2>&1

# index new bam samtools/picard
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar $picard BuildBamIndex \
      I=${out}/${i}.sorted.rg.bam
      
# Mark Duplicates & Index - this is the generalized command
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar $picard MarkDuplicates \
       I=${out}/${i}.sorted.rg.bam\
       O=${out}/${i}.sorted.rg.dedup.bam \
       M=${out}/${i}.metrics.txt \
       CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
       >> ${out}/${i}.dedup.out 2>&1
done




rm *.sorted.bam
rm *.sorted.rg.bam
rm *.sorted.rg.bam.bai


# try snakemake for this
# dry run
snakemake -n -p -s Snakefile

# run on 2 cpus
snakemake -c2 -s Snakefile



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




out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_TX
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX
for i in "36bSD" "58bPD"
do
qualimap bamqc -bam ${in}/${i}.sorted.rg.dedup.bam -c /ohta2/meng.yuan/rumex/pollen_competition/chrom.bed \
--java-mem-size=16G -outdir ${out}/${i}
done


A1    1     465013087
A2    329321726
A3    221760844
A4    179199150
X     220000000
Y 503837879



out=/ohta2/meng.yuan/rumex/pollen_competition/bamqc_TX
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX
for i in "36bFLD" "58bMLD" "36bSD" "58bPD"
do
tinycov covplot ${in}/${i}.sorted.rg.dedup.bam \
--out ${out}/${i}.pdf -s 1000 -r 1000000 --whitelist A1,A2,A3,A4,Y,X
done




