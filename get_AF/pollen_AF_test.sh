########################################################
# examine raw MAF
while read -r col1 col2 _; do
	Rscript --vanilla pollen_raf_maf.R "$col1" "$col2"
done < pollen_auto_cov.txt


########################################################
# perform fisher's exact test on AD of leaf and pollen
# get p value for each site
parallel -j 15 --colsep '\t' /usr/local/bin/Rscript --vanilla pollen_AF_test.R {1} {2} :::: pollen_auto_cov.txt

# while read -r col1 col2 _; do
# 	/usr/local/bin/Rscript --vanilla pollen_AF_test.R "$col1" "$col2"
# done < pollen_auto_cov.txt

# plot original p (more computational intensive)
# only need chrom, pos, p_value for plotting
# while read -r col1 col2 _; do
# 	cut -f 1,2,12 cross${col1}_${col2}_test.txt > cross${col1}_${col2}_test.tmp
# 	/usr/local/bin/Rscript --vanilla pollen_AF_plot.R "$col1" "$col2"
# done < pollen_auto_cov.txt

# calculate running avg of p
while read -r col1 col2 _; do
	cut -f 1,2,13 cross${col1}_${col2}_test.txt > cross${col1}_${col2}_test.tmp
	python3 running_avg_p.py cross${col1}_${col2}_test.tmp cross${col1}_${col2}_sliding_p_avg.txt
	rm cross${col1}_${col2}_test.tmp
done < pollen_auto_cov.txt


########################################################
# make separate VCF of each chrom for windowed AF analyses
while read -r col1 col2 _; do
	for i in "A1" "A2" "A3" "A4"; do
		grep ${i} cross${col1}_${col2}_test.txt > cross${col1}_${col2}_pollen_${i}.vcf
		start_pos=$(head -n 1 cross${col1}_${col2}_pollen_${i}.vcf | cut -f2)
		# get windowed AF
		python3 get_AF_pollen.py cross${col1}_${col2}_pollen_${i}.vcf ${i} ${start_pos}
	done
	cat cross${col1}_${col2}_pollen_*.vcf.freq > cross${col1}_${col2}_pollen.vcf.freq
	rm cross${col1}_${col2}_pollen_A*.vcf
	rm cross${col1}_${col2}_pollen_A*.vcf.freq
done < pollen_auto_cov.txt



########################################################
# plotting everything together 
while read -r col1 col2 _; do
	Rscript --vanilla pollen_AF_p_avg.R "$col1" "$col2"
done < pollen_auto_cov.txt


