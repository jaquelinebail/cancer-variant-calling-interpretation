#!/bin/bash
set -e

bcftools view -f PASS results/filtered/tumor_vs_normal.filtered.vcf.gz -O z -o results/filtered/tumor_vs_normal.pass_only.vcf.gz
bcftools index -t results/filtered/tumor_vs_normal.pass_only.vcf.gz

bcftools filter -e 'FORMAT/AD[0:1]<10' results/filtered/tumor_vs_normal.pass_only.vcf.gz -O z -o results/filtered/tumor_vs_normal.ad10.vcf.gz
bcftools filter -e 'INFO/GERMQ<20' results/filtered/tumor_vs_normal.ad10.vcf.gz -O z -o results/filtered/tumor_vs_normal.ad10.germq20.vcf.gz
bcftools filter -e 'INFO/POPAF<4' results/filtered/tumor_vs_normal.ad10.germq20.vcf.gz -O z -o results/filtered/tumor_vs_normal.final_filtered.vcf.gz

bcftools view -v snps results/filtered/tumor_vs_normal.final_filtered.vcf.gz -O z -o results/filtered/final_filtered.snvs.vcf.gz
bcftools view -v indels results/filtered/tumor_vs_normal.final_filtered.vcf.gz -O z -o results/filtered/final_filtered.indels.vcf.gz
tabix -p vcf results/filtered/final_filtered.snvs.vcf.gz
tabix -p vcf results/filtered/final_filtered.indels.vcf.gz
