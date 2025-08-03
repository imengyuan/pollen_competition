# check seed genotype when parents are homo for diffrent alleles
vi seed_geno.sh
chmod +x seed_geno.sh
parallel -j 20 --colsep '\t' ./seed_geno.sh {1} {2} {3} {4} {5} {6} :::: seed_auto_cov.txt

parallel -j 20 --colsep '\t' ./seed_geno2.sh {1} {2} {3} {4} {5} {6} :::: seed_auto_cov2.txt
