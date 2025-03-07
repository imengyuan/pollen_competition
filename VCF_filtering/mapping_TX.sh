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



