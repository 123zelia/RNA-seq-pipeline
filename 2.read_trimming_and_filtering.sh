#!/bin/bash
set -euo pipefail

# set the path
data_dir="/data/RNA-seq/01/data"
trim_dir="/data/RNA-seq/01/results/trim"
trim_fastqc="/data/RNA-seq/01/results/trim/fastqc"
trim_multiqc="/data/RNA-seq/01/results/trim/multiqc"
# use conda environment
source /data/software/miniconda3/etc/profile.d/conda.sh
conda activate RNA_env

# create folders
mkdir -p "${trim_dir}"

# step1. Read trimming and filtering
for i in {12..19};do
    trim_galore --paired --cores 4 \
      -o ${trim_dir} \
      ${data_dir}/CDNA${i}/CDNA${i}_1.fq.gz \
      ${data_dir}/CDNA${i}/CDNA${i}_2.fq.gz
done
# step2. fastqc after filtering

mkdir -p "${trim_fastqc}" "${trim_multiqc}"
fastqc -t 4 -o ${trim_fastqc}/ -f fastq ${trim_dir}/*.fq.gz
multiqc ${trim_fastqc}/ -o ${trim_multiqc}/