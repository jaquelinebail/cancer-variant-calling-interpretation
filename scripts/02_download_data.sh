#!/bin/bash
set -e
cd data/raw

prefetch --max-size 100G SRR7890827
fasterq-dump SRR7890827 --split-files -O normal/ -e 16
mv normal/SRR7890827_1.fastq normal/normal_1.fastq
mv normal/SRR7890827_2.fastq normal/normal_2.fastq

prefetch --max-size 100G SRR7890824
fasterq-dump SRR7890824 --split-files -O tumor/ -e 16
mv tumor/SRR7890824_1.fastq tumor/tumor_1.fastq
mv tumor/SRR7890824_2.fastq tumor/tumor_2.fastq
cd ../..
