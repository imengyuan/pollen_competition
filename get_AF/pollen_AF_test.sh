# perform fisher's exact test on AD of leaf and pollen
while read -r col1 col2 _; do
	/usr/local/bin/Rscript --vanilla pollen_AF_test.R "$col1" "$col2"
done < pollen_auto_cov.txt


# only need chrom, pos, p_value for plotting
while read -r col1 col2 _; do
	cut -f 1,2,12 cross${col1}_${col2}_test.txt > cross${col1}_${col2}_test.tmp
	/usr/local/bin/Rscript --vanilla pollen_AF_plot.R "$col1" "$col2"
done < pollen_auto_cov.txt


# remove tem files
rm  *_test.tmp