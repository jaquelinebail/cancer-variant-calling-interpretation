#!/bin/bash
set -e

gatk Mutect2 \
  -R data/reference/Homo_sapiens_assembly38.fasta \
  -I data/aligned/tumor/tumor.analysis-ready.bam \
  -I data/aligned/normal/normal.analysis-ready.bam \
  -normal HCC1395BL \
  --germline-resource data/reference/af-only-gnomad.hg38.vcf.gz \
  --panel-of-normals data/reference/1000g_pon.hg38.vcf.gz \
  --f1r2-tar-gz results/somatic/f1r2.tar.gz \
  -O results/somatic/tumor_vs_normal.raw.vcf.gz

gatk LearnReadOrientationModel \
  -I results/somatic/f1r2.tar.gz \
  -O results/somatic/read-orientation-model.tar.gz

gatk GetPileupSummaries -I data/aligned/tumor/tumor.analysis-ready.bam \
  -V data/reference/small_exac_common_3.hg38.vcf.gz \
  -L data/reference/small_exac_common_3.hg38.vcf.gz \
  -O results/somatic/tumor_pileups.table

gatk GetPileupSummaries -I data/aligned/normal/normal.analysis-ready.bam \
  -V data/reference/small_exac_common_3.hg38.vcf.gz \
  -L data/reference/small_exac_common_3.hg38.vcf.gz \
  -O results/somatic/normal_pileups.table

gatk CalculateContamination \
  -I results/somatic/tumor_pileups.table \
  -matched results/somatic/normal_pileups.table \
  -O results/somatic/contamination.table

gatk FilterMutectCalls \
  -R data/reference/Homo_sapiens_assembly38.fasta \
  -V results/somatic/tumor_vs_normal.raw.vcf.gz \
  --contamination-table results/somatic/contamination.table \
  --ob-priors results/somatic/read-orientation-model.tar.gz \
  -O results/filtered/tumor_vs_normal.filtered.vcf.gz
