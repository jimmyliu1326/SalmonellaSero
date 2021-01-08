# SamnSero

## Description
The snakemake pipeline functions to predict Salmonella serotypes from raw Nanopore sequencing data. The pipeline uses flye to assemble the long reads, medaka for genome polishing, and SISTR for in-silico serotyping.

## Usage
```
Required arguments:
-i|--input    Path to input samples.csv containing sample name and path to DIRECTORIES containing multiple fastq files, no headers required
-o|--output   Path to output directory

Optional arguments:
--notrim      Disable adapator trimming by porechop
-t|--threads  Number of threads
-h|--help     Display help message
```

Example command line for pipeline execution:
```
SamnSero.sh -i samples.csv -o path/to/output
```

## Dependencies
* medaka >= 2.1
* flye >= 2.7
* snakemake >= 3.1.3
* porechop >= 0.2.4
* sistr >= 1.1.1