#!/bin/bash
set -e

mkdir -p data/truth_set
wget -O data/truth_set/high-confidence_sSNV_v1.2.vcf.gz "https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/seqc/Somatic_Mutation_WG/release/latest/high-confidence_sSNV_in_HC_regions_v1.2.vcf.gz"
wget -O data/truth_set/high-confidence_sINDEL_v1.2.vcf.gz "https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/seqc/Somatic_Mutation_WG/release/latest/high-confidence_sINDEL_in_HC_regions_v1.2.vcf.gz"
tabix -p vcf data/truth_set/high-confidence_sSNV_v1.2.vcf.gz
tabix -p vcf data/truth_set/high-confidence_sINDEL_v1.2.vcf.gz

bcftools isec -p results/comparison_snv results/filtered/final_filtered.snvs.vcf.gz data/truth_set/high-confidence_sSNV_v1.2.vcf.gz
bcftools isec -p results/comparison_indel results/filtered/final_filtered.indels.vcf.gz data/truth_set/high-confidence_sINDEL_v1.2.vcf.gz
