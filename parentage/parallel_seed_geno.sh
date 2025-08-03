# check seed genotype when parents are homo for diffrent alleles
vi seed_geno.sh
chmod +x seed_geno.sh
parallel -j 20 --colsep '\t' ./seed_geno.sh {1} {2} {3} {4} {5} {6} :::: seed_auto_cov.txt


# remove intermediate files
ls *.filt.vcf.gz*
rm *.filt.vcf.gz*

# count genotypes
while read -r col1 col2 col3 _; do
	Rscript --vanilla count_GT.R "$col1" "$col2" "$col3"
done < seed_auto_cov.txt

