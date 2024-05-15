# Snakefile
# out=/ohta2/meng.yuan/rumex/pollen_competition/AnalysisReady_TX
# in=/ohta2/meng.yuan/rumex/pollen_competition/BAM_TX
# picard=/ohta1/bianca.sacchi/bin/picard/build/libs/picard.jar

rule mark_duplicates:
    input:
        bam="{out}/{sample}.sorted.rg.bam"
    output:
        dedup_bam="{out}/{sample}.sorted.rg.dedup.bam",
        metrics="{out}/{sample}.metrics.txt",
        index="{out}/{sample}.sorted.rg.dedup.bam.bai"
    params:
        tmp_dir="/ohta2/meng.yuan/tmp"
    shell:
        """
        java -Djava.io.tmpdir={params.tmp_dir} -jar $picard MarkDuplicates \
            I={input.bam} \
            O={output.dedup_bam} \
            M={output.metrics} \
            CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
            >> {output.dedup_bam}.dedup.out 2>&1
        """

rule all:
    input:
        expand("{out}/{sample}.sorted.rg.dedup.bam.bai", out=config["output_directory"], sample=config["samples"])
