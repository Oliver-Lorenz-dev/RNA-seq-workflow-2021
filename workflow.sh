#!/usr/bin/bash

# download data
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/000/SRR3437050/SRR3437050_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/000/SRR3437050/SRR3437050_2.fastq.gz

# quality control
fastqc *fastq.gz -o QC

multiqc QC

# preprocessing
fastp -i SRR3437050_1.fastq.gz -I SRR3437050_2.fastq.gz -o processed_reads/SRR3437050_1.fastq.gz -O processed_reads/SRR3437050_2.fastq.gz --detect_adapter_for_pe -c

# read quantification
salmon quant -i processed_reads/human_v38_index -l A -1 SRR3437050_1.fastq.gz -2 SRR3437050_2.fastq.gz -o processed_reads/read_counts_2
