### workflow ###

with open("sample_cross1.txt", "r") as file:
    samples = [line.strip() for line in file if line.strip()]

# This rule establishes the names of output files from other rules
rule all:
     input:
          markdup = expand("AnalysisReady_TX/{sample}_sortMarkDups.bam", sample = samples),
          bamidx = expand("AnalysisReady_TX/{sample}_sortMarkDups.bam.bai", sample = samples),



# This rule runs samtools fixmate, samtools sort, and samtools markduplicates

rule samtools_markdup:
    """
    Mark duplicate reads using samtools. Output sorted BAM.
    """
    input: 
        in = "AnalysisReady_TX/{sample}.sorted.rg.bam"
    output:
        bam = 'AnalysisReady_TX/{sample}_sortMarkDups.bam',
        stats = 'duplication_stats/{sample}_dupStats.txt'
    log: 'logs/samtools_markdup/{sample}_samtools_markdup.log'
    threads: 6
    resources:
        tmpdir="/ohta2/meng.yuan/tmp"
    shell:
        """
        ( samtools fixmate --threads {threads} -m {input.in} - |\
            samtools sort --threads {threads} -T {resources.tmpdir}/{wildcards.sample} -o - |\
            samtools markdup --threads {threads} -T {resources.tmpdir}/{wildcards.sample} -f {output.stats} - {output.bam} ) 2> {log}
        """

# This rule indexes final bams
rule index_bam:
    """
    Index sorted BAM with marked duplicates
    """
    input:
        rules.samtools_markdup.output.bam
    output:
         bamidx = 'AnalysisReady_TX/{sample}_sortMarkDups.bam.bai',
    log: 'logs/index_bam/{sample}_index_bam.log'
    threads: 20
    resources:
          tmpdir="/ohta2/meng.yuan/tmp"
    shell:
        """
        samtools index -@ {threads} {input} 2> {log}
        """