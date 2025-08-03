# extract ready-to-use VCF for each cross
while read -r col1 col2 _ _ col5 col6 _; do
    sh pollen_vcf.sh "$col1" "$col2" "$col5" "$col6"
    sed -i 's/\,/\t/g' cross${col1}_${col2}_pollen.vcf
done < pollen_auto_cov.txt

   # 6944314 cross10_15c_pollen.vcf
   # 6078268 cross1_31c_pollen.vcf
   # 7285354 cross2_02f_pollen.vcf
   # 6353588 cross3_37h_pollen.vcf
   # 8018639 cross4_55e_pollen.vcf
   # 6882685 cross5_35h_pollen.vcf
   # 7758406 cross6_30f_pollen.vcf
   # 7809214 cross7_58b_pollen.vcf
   # 6674863 cross8_48d_pollen.vcf
   # 7259762 cross9_34b_pollen.vcf

