# calculate AF in pollen and seed in sliding windows for each cross
import sys
import re
# usage: python3 get_AF.py XX.vcf.table
# X       587     C       G,<*>,T,A       0/0:17:.        0/0:31:.        ./.:104:103,1,0,.,.     ./.:131:129,.,0,1,1


f_in = open(sys.argv[1], "r")
out_file = sys.argv[1] + ".AF"
f_out = open(out_file, "w")
# print header line of the output
print('chrom\tpos\tGT_dad\tGT_mom\tcnt_ref_pollen\tcnt_alt_pollen\tcnt_ref_seed\tcnt_alt_seed', file=f_out)

# filter for sites where dad=0/1, mom=0/0 or 1/1, export the numbers(AD)
content = f_in.readlines()
for line in content:  # loop through each line of the vcf
    result_list = []  # a list keeping outputs of each line
    vcf_line = line.split()  # eg. ['chrom_1','pos_1','G','A',...]
    #print(vcf_line)
    dad = vcf_line[4]
    mom = vcf_line[5]
    pollen = vcf_line[6]
    seed = vcf_line[7]
    #print(mom, dad, pollen, seed)

    # filter parent genotypes and output AD fields
    if dad[0:3] == '0/1' and mom[0:3] != '0/1':
        result_list.append(vcf_line[0])  # chrom
        result_list.append(vcf_line[1])  # pos
        result_list.append(dad[0:3])  # GT_dad
        result_list.append(mom[0:3])  # GT_mom

        # ./.:109,2,1,0
        AD_pollen = re.findall(r'\d+', pollen)
        AD_seed = re.findall(r'\d+', seed)
        # first get the entire AD [4:]
        # then split by , then extract first 2 items, convert . to 0

        cnt_ref_pollen = AD_pollen[0]
        cnt_alt_pollen = AD_pollen[1]
        cnt_ref_seed = AD_seed[0]
        cnt_alt_seed = AD_seed[1]

        # add to output
        result_list.append(str(cnt_ref_pollen))
        result_list.append(str(cnt_alt_pollen))
        result_list.append(str(cnt_ref_seed))
        result_list.append(str(cnt_alt_seed))
    else:
        continue
    #print(result_list)
    print("\t".join(result_list), file=f_out)
f_in.close()
f_out.close()


## calculate AF in sliding windows