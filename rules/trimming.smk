rule combine_fastq:
  input:
    fastq_dir=lambda wildcards: samples_meta.Path[wildcards.sample]
  output:
    combined_fastq=temp("{sample}/{sample}.fastq")
  threads: 1
  shell:
    "cat {input.fastq_dir}/*.fastq > {output.combined_fastq}"

rule porechop:
  input:
    reads="{sample}/{sample}.fastq"
  threads: 16
  log:
    "{sample}/logs/porechop.log"
  output:
    trimmed_reads=temp("{sample}/{sample}_trimmed.fastq")
  shell:
    "porechop -t {threads} -i {input.reads} -o {output.trimmed_reads}"