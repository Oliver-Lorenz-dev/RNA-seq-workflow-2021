RNA-seq-workflow-2021
========================================

This document is written to allow anyone to use this RNA-seq analysis workflow.

You can run this workflow on your local computer or on a high performance computer
if you have access to one.

This workflow uses the following software packages: fastqc, multiqc, fastp, salmon and DESeq2.

Software installation
----------------------
This workflow requires the use of a Linux operating system.

This workflow uses the following software packages: fastqc, multiqc, fastp, salmon and DESeq2.

We will install the required bioinformatics tools using Miniconda.

Miniconda installation
----------------------
In your linux terminal type: `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`
to install miniconda.

Once you have downloaded the above shell script run it using the following command:
`bash Miniconda3-latest-Linux-x86_64.sh`

Conda setup
----------------------
First we need to create a conda environment. To do this type `conda create -n rna-seq`

Now we have created a new environment. To work in this environment, we need to activate it.
To do this type `conda activate rna-seq`

Then, we can add channels to the conda environment to make installing bioinformatics software easier.

Use the following commands:

`conda config --add channels default`

`conda config --add channels bioconda`

`conda config --add channels conda-forge`

Installing bioinformatics software
----------------------
To install the required software, use the following commands

`conda install fastqc -y`

`conda install multiqc -y`

`conda install fastp -y`

`conda install salmon -y`

The -y option is included to automatically say yes to any prompts given in the installation process.

All the software needed to generate read count data from raw (FASTQ) RNA-seq data is now installed.
DESeq2 is an R package, we can install this later.

Using the software
----------------------

