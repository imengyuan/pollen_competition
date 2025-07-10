
# chr_pos.txt
A1	1	465013087
A2	1	329321726
A3	1	221760844
A4	1	179199150
Y	1	45000000
Y	45000001	503837879
X	1	220000000

samtools view -c -F 4 31hFLD.sorted.rg.dedup.bam A1:1-465013087
 
file=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX
for i in $(less sampleAll.txt)
do
counts=()
while read -r col1 col2 col3; do
    count=$(samtools view -c -F 4 "${file}/${i}.sorted.rg.dedup.bam" "${col1}:${col2}-${col3}")
    counts+=("$count")
done < chr_pos.txt
echo -e "$i\t${counts[*]}" | tr ' ' '\t' >> read_counts.tsv
done
