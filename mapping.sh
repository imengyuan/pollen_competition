bwa-mem2 index NChap1_final.fa

ref=/ohta2/meng.yuan/rumex/pollen_competition/genome/NChap1_final.fa
parent_dir=/ohta2/meng.yuan/rumex/pollen_competition/fastq_merged
out_dir=/ohta2/meng.yuan/rumex/pollen_competition/BAM_hap1
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sample_subset.txt)
do
bwa-mem2 mem -t 20 ${ref} ${parent_dir}/${i}_R1.fastq.gz ${parent_dir}/${i}_R2.fastq.gz | samtools view -S -b -o ${out_dir}/${i}_hap1_bwa.bam - 
done


bwa-mem2 index NChap2_final.fa

ref=/ohta2/meng.yuan/rumex/pollen_competition/genome/NChap2_final.fa
parent_dir=/ohta2/meng.yuan/rumex/pollen_competition/fastq_merged
out_dir=/ohta2/meng.yuan/rumex/pollen_competition/BAM_hap2
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sample_subset.txt)
do
bwa-mem2 mem -t 20 ${ref} ${parent_dir}/${i}_R1.fastq.gz ${parent_dir}/${i}_R2.fastq.gz | samtools view -S -b -o ${out_dir}/${i}_hap2_bwa.bam - 
done


out=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap2
in=/ohta2/meng.yuan/rumex/pollen_competition/BAM_hap2
picard=/ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleSD.txt)
do
# after getting bwa.bam, sort bam
samtools sort -O bam -t 16 -o ${out}/${i}_hap2.sorted.bam ${in}/${i}_hap2_bwa.bam >> sort1.out 2>&1

# add read group
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar $picard AddOrReplaceReadGroups \
       INPUT=${out}/${i}_hap2.sorted.bam \
       OUTPUT=${out}/${i}_hap2.sorted.rg.bam \
       RGID=${i}_hap2_id \
       RGLB=rumex \
       RGPL=Illumina \
       RGPU=unit1 \
       RGSM=${i}_hap2 \
       >> RG1.out 2>&1

# index new bam samtools/picard
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar $picard BuildBamIndex \
      I=${out}/${i}_hap2.sorted.rg.bam
      
# Mark Duplicates & Index - this is the generalized command
java -Djava.io.tmpdir=/ohta2/meng.yuan/tmp -jar $picard MarkDuplicates \
       I=${out}/${i}_hap2.sorted.rg.bam\
       O=${out}/${i}_hap2.sorted.rg.dedup.bam \
       M=${out}/${i}_hap2.metrics.txt \
       CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
       >> ${i}_hap2.dedup.out 2>&1
done
