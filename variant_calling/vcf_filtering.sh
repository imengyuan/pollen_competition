# filter the vcfs for hap1 hap2 LD.vcf
# pollenLD_hap1.vcf.gz pollenLD_hap2.vcf.gz
# variant sites only

# then filter for ancestry informative sites


# https://speciationgenomics.github.io/filtering_vcfs/
bcftools view pollenLD_hap1.vcf.gz | vcfrandomsample -r 0.012 > pollenLD_hap1_subset.vcf

SUBSET_VCF=pollenLD_hap1_subset.vcf
OUT=pollenLD_hap1_subset.vcf
# mean depth of per individual
vcftools --gzvcf $SUBSET_VCF --depth --out $OUT

# mean depth per site
vcftools --gzvcf $SUBSET_VCF --site-mean-depth --out $OUT

# proportion of missing data per site
vcftools --gzvcf $SUBSET_VCF --missing-site --out $OUT

# no need to do above, can just use the results from qualimap
# Warning: Expected at least 2 parts in INFO entry: ID=SGB,Number=1,Type=Float,Description="Segregation based metric, http://samtools.github.io/bcftools/rd-SegBias.pdf">
# Warning: Expected at least 2 parts in INFO entry: ID=AC,Number=A,Type=Integer,Description="Allele count in genotypes for each ALT allele, in the same order as listed">
# Warning: Expected at least 2 parts in INFO entry: ID=DP4,Number=4,Type=Integer,Description="Number of high-quality ref-forward , ref-reverse, alt-forward and alt-reverse bases">
# Warning: Expected at least 2 parts in INFO entry: ID=DP4,Number=4,Type=Integer,Description="Number of high-quality ref-forward , ref-reverse, alt-forward and alt-reverse bases">


# set missingness and DP cutoff
# filter VCF
vcftools --gzvcf pollenLD_hap1.vcf.gz \
--mac 1 \
--remove-indels \
--max-missing 0.8 \
--minQ 30 \
--min-alleles 2 --max-alleles 2 \
--min-meanDP 10 \
--max-meanDP 40 \
--recode --stdout | bgzip -c > pollenLD_hap1_variant.vcf.gz

tabix pollenLD_hap1_variant.vcf.gz

vcftools --gzvcf pollenLD_hap2.vcf.gz \
--mac 1 \
--remove-indels \
--max-missing 0.8 \
--minQ 30 \
--min-alleles 2 --max-alleles 2 \
--min-meanDP 10 \
--max-meanDP 40 \
--recode --stdout | bgzip -c > pollenLD_hap2_variant.vcf.gz




