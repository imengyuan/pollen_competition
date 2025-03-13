# extract ready-to-use VCF for each cross
while read -r col1 col2 _ _ col5 col6 _; do
    sh pollen_vcf.sh "$col1" "$col2" "$col5" "$col6"
    sed -i 's/\,/\t/g' cross${col1}_${col2}_pollen.vcf
done < pollen_auto_cov.txt

# make separate VCF of each chrom for windowed AF analyses
while read -r col1 col2 _; do
	for i in "A1" "A2" "A3" "A4"; do
		grep ${i} cross${col1}_${col2}_pollen.vcf > cross${col1}_${col2}_pollen_${i}.vcf
		start_pos=$(head -n 1 cross${col1}_${col2}_pollen_${i}.vcf | cut -f2)
		python3 get_AF_pollen.py cross${col1}_${col2}_pollen_${i}.vcf ${i} ${start_pos}
	done
	cat cross${col1}_${col2}_pollen_*.vcf.freq > cross${col1}_${col2}_pollen.vcf.freq
	rm cross${col1}_${col2}_pollen_A*.vcf
	rm cross${col1}_${col2}_pollen_A*.vcf.freq
done < pollen_auto_cov.txt


# perform fisher's exact test on AD of leaf and pollen
while read -r col1 col2 _; do
	/usr/local/bin/Rscript --vanilla pollen_AF_test.R "$col1" "$col2"
done < pollen_auto_cov.txt

