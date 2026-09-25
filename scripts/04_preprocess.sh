#!/bin/bash
set -e

for SAMPLE in normal tumor; do
  gatk MarkDuplicates \
    -I data/aligned/$SAMPLE/$SAMPLE.sorted.bam \
    -O data/aligned/$SAMPLE/$SAMPLE.dedup.bam \
    -M results/germline/${SAMPLE}_dup_metrics.txt

  gatk BaseRecalibrator \
    -I data/aligned/$SAMPLE/$SAMPLE.dedup.bam \
    -R data/reference/Homo_sapiens_assembly38.fasta \
    --known-sites data/reference/Homo_sapiens_assembly38.dbsnp138.vcf \
    --known-sites data/reference/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
    -O results/germline/${SAMPLE}_recal.table

  gatk ApplyBQSR \
    -I data/aligned/$SAMPLE/$SAMPLE.dedup.bam \
    -R data/reference/Homo_sapiens_assembly38.fasta \
    --bqsr-recal-file results/germline/${SAMPLE}_recal.table \
    -O data/aligned/$SAMPLE/$SAMPLE.analysis-ready.bam

  samtools index data/aligned/$SAMPLE/$SAMPLE.analysis-ready.bam
done
