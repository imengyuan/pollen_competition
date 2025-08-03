# remove multi-allelic sites in pollen where AF of 3rd and 4th allele > 5%
id="$1"
male="$2"

vcf_leaf=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${male}MLD.filt.vcf.gz
vcf_pollen=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/${male}PD.filt.vcf.gz
pileup=/ohta2/meng.yuan/rumex/pollen_competition/pileup/${male}PD.pileup.vcf.gz

vcf_out=/ohta2/meng.yuan/rumex/pollen_competition/pileup/${male}_merged.filt.vcf
vcf_skewed=/ohta2/meng.yuan/rumex/pollen_competition/pileup/${male}_merged.filt_skewed.vcf
vcf_in=/ohta2/meng.yuan/rumex/pollen_competition/cross_TX/cross${id}_${male}_pollen.vcf
vcf_filt=/ohta2/meng.yuan/rumex/pollen_competition/pileup/cross${id}_${male}_pollen.filt.vcf

# merge VCFs
bcftools merge ${vcf_leaf} ${vcf_pollen} ${pileup} --force-samples --threads 20 | \
bcftools filter -e 'FMT/DP="."' --threads 20 | \
bcftools view -i 'N_ALT>2' --threads 20 | \
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT\t%AD]\n' > ${vcf_out}

# identify and remove skewed sites
awk -F'\t' '{
    split($10, a, ",");
    if ((a[3]+a[4])/(a[1]+a[2]+a[3]+a[4]) > 0.05)
        print
}' ${vcf_out} > ${vcf_skewed}

awk -F'\t' 'NR==FNR {a[$1 FS $2]; next} !($1 FS $2 in a)' \
${vcf_skewed} ${vcf_in} > ${vcf_filt}
