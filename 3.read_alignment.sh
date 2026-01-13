#!/bin/bash
set -euo pipefail

# set the path
reference_dir="/data/RNA-seq/reference/mouse"
reference_index_dir="/data/RNA-seq/reference/mouse/bowtie2Index"
trim_dir="/data/RNA-seq/01/results/trim"
alignment_dir="/data/RNA-seq/01/results/bowtie2"

# use conda environment
source /data/software/miniconda3/etc/profile.d/conda.sh
conda activate RNA_env

# create folders
mkdir -p ${alignment_dir}
mkdir -p ${alignment_dir}/sam
mkdir -p ${alignment_dir}/sam/bowtie2_summary
mkdir -p ${alignment_dir}/bam

# build index
gunzip ${reference_dir}/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
bowtie2-build ${reference_dir}/Mus_musculus.GRCm39.dna.primary_assembly.fa  ${reference_index_dir}/GRCm39.genome.mm


# mapping
for i in {12..19};do
    bowtie2 \
    --local --very-sensitive --no-mixed --no-discordant --phred33 \
    -I 10 -X 700 -p 4 \
    --rg-id CDNA"$i" --rg SM:CDNA"$i" \
    -x ${reference_index_dir}/GRCm39.genome.mm \
    -1 ${trim_dir}/CDNA${i}_1_val_1.fq.gz \
    -2 ${trim_dir}/CDNA${i}_2_val_2.fq.gz \
    -S ${alignment_dir}/sam/CDNA${i}_bowtie2.sam &> ${alignment_dir}/sam/bowtie2_summary/CDNA${i}_bowtie2.txt   
    # sam to bam  
    samtools view -bS -F 0x04 ${alignment_dir}/sam/CDNA${i}_bowtie2.sam -o ${alignment_dir}/bam/RCDNA${i}_bowtie2.bam  
    samtools sort ${alignment_dir}/bam/CDNA${i}_bowtie2.bam -o ${alignment_dir}/bam/CDNA${i}_bowtie2.sort.bam
    samtools index ${alignment_dir}/bam/CDNA${i}_bowtie2.sort.bam

done
