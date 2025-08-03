import csv
import sys
from collections import defaultdict

# Parameters
WINDOW_SIZE = 1000
STEP_SIZE = 100

# Input and output filenames
input_file = sys.argv[1]
output_file = sys.argv[2]

# Read the input file (tab-delimited)
data_by_chrom = defaultdict(list)

with open(input_file, newline='') as infile:
    reader = csv.reader(infile, delimiter='\t')
    header = next(reader)  # Skip header
    for row in reader:
        chrom = row[0]
        position = int(row[1])
        p_value = float(row[2])
        data_by_chrom[chrom].append((position, p_value))

# Compute sliding window averages
def sliding_window(data, window_size=1000, step=100):
    results = []
    for chrom in sorted(data):
        rows = data[chrom]
        for i in range(0, len(rows) - window_size + 1, step):
            window = rows[i:i + window_size]
            avg = sum(x for _, x in window) / window_size
            center_pos = window[window_size // 2][0]
            results.append((chrom, center_pos, avg))
    return results

# Run the function
averaged_results = sliding_window(data_by_chrom)

# Write output to a tab-delimited .txt file
with open(output_file, mode="w", newline='') as outfile:
    writer = csv.writer(outfile, delimiter='\t')
    writer.writerow(["chrom", "mid_pos", "p_value_avg"])
    for chrom, center_pos, avg_x in averaged_results:
        writer.writerow([chrom, center_pos, round(avg_x, 6)])

print(f"Done. Output written to '{output_file}'")
