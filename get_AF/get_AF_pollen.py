# calculate AF in pollen and dad in sliding windows
# usage: python3 get_AF.py XX.vcf
# X       22606   G       A       0/1     5       3       0/1     66      13

import sys
vcf_file = sys.argv[1]
out_file = sys.argv[1] + ".freq"
f_out = open(out_file, "w")
# print header line of the output
print('chrom\tstart\tend\tno_sites\tdad_freq\tpollen_freq', file=f_out)

# assign window size and step size
window = 1000000  # 1Mb
step = 1000000

chrom = sys.argv[2]
start_pos = int(sys.argv[3])

# initializing variables
n = 1  # window number
result_list = []
no_sites, dad_0, dad_1, pollen_0, pollen_1 = 0, 0, 0, 0, 0


def calculate_freq(dad_0, dad_1, pollen_0, pollen_1):
    if dad_0 + dad_1 != 0 and pollen_0 + pollen_1 != 0:
        dad_freq = dad_0 / float(dad_0 + dad_1)
        pollen_freq = pollen_0 / float(pollen_0 + pollen_1)
    else:
        dad_freq, pollen_freq = 0, 0
    return dad_freq, pollen_freq


with open(vcf_file, "r") as f_in:
    for line in f_in:
        record = line.strip().split()
        pos = int(record[1])

        if pos < (n - 1) * step + start_pos + window:
            # Calculate total read count in AD for dad and pollen
            dad_0 += int(record[5])
            dad_1 += int(record[6])
            pollen_0 += int(record[8])
            pollen_1 += int(record[9])
            no_sites += 1
        else:
            start = (n - 1) * step + start_pos
            end = start + window - 1
            dad_freq, pollen_freq = calculate_freq(dad_0, dad_1, pollen_0, pollen_1)
            result_list.append([chrom, str(start), str(end), str(no_sites), str(dad_freq), str(pollen_freq)])

            n += 1
            no_sites, dad_0, dad_1, pollen_0, pollen_1 = 0, 0, 0, 0, 0

            # Process the current record again for the new window
            dad_0 += int(record[5])
            dad_1 += int(record[6])
            pollen_0 += int(record[8])
            pollen_1 += int(record[9])
            no_sites += 1

    # Last window
    start = (n - 1) * step + start_pos
    end = start + window - 1
    dad_freq, pollen_freq = calculate_freq(dad_0, dad_1, pollen_0, pollen_1)
    result_list.append([chrom, str(start), str(end), str(dad_freq), str(pollen_freq)])

for result in result_list:
    print("\t".join(result), file=f_out)

f_out.close()