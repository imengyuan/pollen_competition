M F
31c	30a

30aSD finished

30aFLD 31cMLD 31cPD 30aSD

# for leaf: not necessary for calling snps jointly
# at leaset not the trial
# might be ready to run at the end of the day

# leaf
# use freebayes instead of mpileup
ref=/ohta2/meng.yuan/rumex/pollen_competition/NC/genome/NChap1_final.fa
bamlist=/ohta2/meng.yuan/rumex/pollen_competition/NC/pollenLD_hap1_test.txt
output=/ohta2/meng.yuan/rumex/pollen_competition/vcf/pollenLD_31c_30a_hap1.vcf.gz
bcftools mpileup -a DP -B -I -f ${ref} -b ${bamlist} --threads 20 | bcftools call --threads 20 -m -O z -o ${output}
# so we have FMT/DP


# SD PD
ref=/ohta2/meng.yuan/rumex/pollen_competition/genome/NChap1_final.fa
in=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_hap1/
out=/ohta2/meng.yuan/rumex/pollen_competition/vcf2/
for i in $(less /ohta2/meng.yuan/rumex/pollen_competition/sampleSD.txt)
do
bcftools mpileup -a DP,AD -d 5000 -Ov -f ${ref} ${in}/${i}_hap1.sorted.rg.dedup.bam --threads 15 \
 > ${out}/${i}_hap1.pileup.vcf
done



# merge VCF for cross 1 test
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
# what happen to DP here???
# X       8       .       C       .       20.5032 .       DP=2;SGB=-0.0262599;RPBZ=1;MQBZ=0;BQBZ=0;SCBZ=-1;MQ0F=1;AN=4;DP4=1,0,1,0;MQ=0   GT      ./.     ./.     0/0     ./.     ./.     ./.     ./.     ./.     ./.     0/0
# cant have missing genotype
bcftools view -s ${mom} ${vcf_in} | bcftools filter -e \
'FMT/GQ<50 && FMT/DP>42 && GT ="."' --threads 20 -O z -o ${vcf_out_mom}
bcftools view -s ${dad} ${vcf_in} | bcftools filter -e \
'FMT/GQ<50 && FMT/DP>42 && GT ="."' --threads 20 -O z -o ${vcf_out_dad}

# filter seed and pollen
# X       8       .       C       <*>     0       .       DP=1;I16=1,0,0,0,37,1369,0,0,0,0,0,0,11,121,0,0;QS=1,0;MQ0F=1   PL:DP:ADF:ADR:AD        0,3,4:1:1,0:0,0:1,0
bcftools filter -e 'FMT/DP<50 && FMT/DP>154' ${vcf_seed} \
--threads 20 -O z -o ${vcf_out_seed}
bcftools filter -e 'FMT/DP<50 && FMT/DP>159' ${vcf_pollen} \
--threads 20 -O z -o ${vcf_out_pollen}

# merge samples for the cross
tabix ${vcf_out_mom}
tabix ${vcf_out_dad}
tabix ${vcf_out_seed}
tabix ${vcf_out_pollen}

# the output field should include GT, DP, AD
bcftools merge ${vcf_out_dad} ${vcf_out_mom} ${vcf_out_seed} ${vcf_out_pollen} \
--threads 20 | bgzip > ${vcf_out}
