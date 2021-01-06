rule flye:
  input: 
    reads=assembly_input
  output:
    flye_dir="{sample}/flye",
    assembly="{sample}/{sample}_flye.fasta"
  threads: 16
  log: "{sample}/logs/flye.log"
  shell:
    """
    flye --nano-raw {input.reads} -t {threads} -i 2 -g 4.5m --out-dir {output.flye_dir}
    cp {output.flye_dir}/assembly.fasta {output.assembly}
    """

rule medaka:
  input:
    assembly="{sample}/{sample}_flye.fasta",
    reads=assembly_input
  output:
    medaka_dir="{sample}/medaka",
    polished_asm="{sample}/{sample}_consensus.fasta"
  threads: 16
  log: "{sample}/logs/medaka.log"
  shell:
    """
    medaka_consensus -i {input.reads} -d {input.assembly} -o {output.medaka_dir} -t {threads} -f
    cp {output.medaka_dir}/consensus.fasta {output.polished_asm}
    """