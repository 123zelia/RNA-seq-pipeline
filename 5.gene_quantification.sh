#!/bin/bash
set -euo pipefail

# set the path
alignment_dir="/data/RNA-seq/01/results/bowtie2/bam"
GTF_dir="/data/RNA-seq/reference/mouse"
counts_dir="/data/RNA-seq/01/results/counts"

# use conda environment
source /data/software/miniconda3/etc/profile.d/conda.sh
conda activate RNA_env

# create folders
mkdir -p "${counts_dir}"

featureCounts -T 4 -p -a ${GTF_dir}/Mus_musculus.GRCm39.114.chr.gtf -g exon_id -f \
-o ${counts_dir}/gene_counts.txt \
-Q 10 \
${alignment_dir}/*.sort.bam

