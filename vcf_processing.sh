# get GT from parents

bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' pollenLD_hap1_variant.vcf.gz  \
> ${i}.filt.syn.vcf.txt


# need to look at one family trio alone
# select and merge a VCF of 3 samples