# perform fisher's exact test on AD of leaf and pollen
while read -r col1 col2 _; do
	/usr/local/bin/Rscript --vanilla pollen_AF_test.R "$col1" "$col2"
done < pollen_auto_cov.txt


# only need chrom, pos, p_value for plotting
while read -r col1 col2 _; do
	cut -f 1,2,12 cross${col1}_${col2}_test.txt > cross${col1}_${col2}_test.tmp
	/usr/local/bin/Rscript --vanilla pollen_AF_plot.R "$col1" "$col2"
done < pollen_auto_cov.txt

# calculate running avg of p
while read -r col1 col2 _; do
	python3 running_avg_p.py cross${col1}_${col2}_test.tmp cross${col1}_${col2}_sliding_p_avg.txt
done < pollen_auto_cov.txt

while read -r col1 col2 _; do
	Rscript --vanilla pollen_AF_p_avg.R "$col1" "$col2"
done < pollen_auto_cov.txt
