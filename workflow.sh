#!/usr/bin/bash


# data download
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/000/SRR3437050/SRR3437050_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/000/SRR3437050/SRR3437050_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/009/SRR3437049/SRR3437049_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/009/SRR3437049/SRR3437049_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/002/SRR3437052/SRR3437052_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/002/SRR3437052/SRR3437052_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/001/SRR3437051/SRR3437051_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/001/SRR3437051/SRR3437051_2.fastq.gz

# QC
mkdir QC

fastqc *fastq.gz -o QC

multiqc QC

# pre processing
for index in {49..52}
do
       fastp -i SRR34370"${index}"_1.fastq.gz -I SRR34370"${index}"_2.fastq.gz -o processed_reads/SRR34370"${index}"_1.fastq.gz -O processed_reads/SRR34370"${index}"_2.fastq.gz --detect_adapter_for_pe -c -R "SRR34370"${index}"" -h "SRR34370"${index}".html"
done

# read quantification
for index in {49..52}
do
        salmon quant -i processed_reads/human_v38_index -l A -1 processed_reads/SRR34370"${index}"_1.fastq.gz -2 processed_reads/SRR34370"${index}"_2.fastq.gz -o processed_reads/SRR34370"${index}"
done

