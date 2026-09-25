#!/bin/bash
set -e

bwa mem -t 16 -R "@RG\tID:normal\tSM:HCC1395BL\tPL:ILLUMINA\tLB:lib1" \
  data/reference/Homo_sapiens_assembly38.fasta \
  data/raw/normal/normal_1.fastq data/raw/normal/normal_2.fastq \
  | samtools sort -@ 16 -o data/aligned/normal/normal.sorted.bam
samtools index data/aligned/normal/normal.sorted.bam

bwa mem -t 16 -R "@RG\tID:tumor\tSM:HCC1395\tPL:ILLUMINA\tLB:lib1" \
  data/reference/Homo_sapiens_assembly38.fasta \
  data/raw/tumor/tumor_1.fastq data/raw/tumor/tumor_2.fastq \
  | samtools sort -@ 16 -o data/aligned/tumor/tumor.sorted.bam
samtools index data/aligned/tumor/tumor.sorted.bam
