#!/usr/bin/env bash

usage() {
echo "
SamnSero.sh [options]

Required arguments:
-i|--input          .csv file with first column as sample name and second column as path to DIRECTORIES containing fastq files, no headers required

Optional arguments:
-t|--threads        Number of threads [Default = 32]
-h|--help           Display help message
"
}

# initialize variables
THREADS=32
AGGREGATE_PATH=""
AGGREGATE=0
TRIM=1

# get script directory
script_dir=$(dirname $(realpath $0))

# parse arguments
opts=`getopt -o hi:o:t: -l help,input:,output:,threads:,db:,notrim,aggregate: -- "$@"`
eval set -- "$opts"
if [ $? != 0 ] ; then echo "SamnSero: Invalid arguments used, exiting"; usage; exit 1 ; fi
if [[ $1 =~ ^--$ ]] ; then echo "SamnSero: Invalid arguments used, exiting"; usage; exit 1 ; fi

while true; do
    case "$1" in
        -i|--input) INPUT_PATH=$2; shift 2;;
        -t|--threads) THREADS=$2; shift 2;;
        --notrim) TRIM=0; shift 1;;
        --aggregate) AGGREGATE_PATH=$(realpath $2); AGGREGATE=1; shift 2;;
        --) shift; break ;;
        -h|--help) usage; exit 0;;
    esac
done

# check if required arguments present
if test -z $INPUT_PATH; then echo "SamnSero: Required argument -i is missing, exiting"; exit 1; fi

# check if dependencies are installed
medaka_consensus -h 2&>1 /dev/null
if [[ $? != 0 ]]; then echo "SamnSero: medaka cannot be called, check its installation"; exit 1; fi

sistr -h 2&>1 /dev/null
if [[ $? != 0 ]]; then echo "SamnSero: sistr cannot be called, check its installation"; exit 1; fi

flye -h 2&>1 /dev/null
if [[ $? != 0 ]]; then echo "SamnSero: sistr cannot be called, check its installation"; exit 1; fi

snakemake -h > /dev/null
if [[ $? != 0 ]]; then echo "SamnSero: snakemake cannot be called, check its installation"; exit 1; fi

porechop -h > /dev/null
if [[ $? != 0 ]]; then echo "SamnSero: porechop cannot be called, check its installation"; exit 1; fi

# validate input samples.csv
if ! test -f $INPUT_PATH; then echo "SamnSero: Input sample file does not exist, exiting"; exit 1; fi

while read lines; do
  sample=$(echo $lines | cut -f1 -d',')
  path=$(echo $lines | cut -f2 -d',')
  if ! test -d $path; then
    echo "SamnSero: The listed fastq directory for ${sample} cannot be found, check its path listed in the input file, exiting"
    exit 1
  fi
done < $INPUT_PATH

# call snakemake
snakemake --snakefile $script_dir/SnakeFile --cores $THREADS \
  --config samples=$(realpath $INPUT_PATH) outdir=/mnt/e/data/staging pipeline_dir=$script_dir trim=$TRIM outfile=$AGGREGATE_PATH aggregate=$AGGREGATE

# clean up
rm /mnt/e/data/staging/.snakemake