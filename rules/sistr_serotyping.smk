rule sistr:
  input:
    polished_asm="{sample}/{sample}_consensus.fasta"
  output:
    sistr_res="{sample}/{sample}_sistr_res.csv"
  params:
    sample_name="{sample}"
  threads: 8
  log: "{sample}/logs/sistr.log"
  shell:
    "sistr -i {input.polished_asm} {params.sample_name} -o {output.sistr_res} -t {threads} -f csv --qc"

rule aggregate:
  input:
    sistr_res=expand("{sample}/{sample}_sistr_res.csv", sample=samples_meta.Sample)
  output:
    aggregate_res=config['outfile']
  threads: 1
  shell:
    "awk 'NR == 1 || FNR > 1' {input.sistr_res} > {output.aggregate_res}"
