RNA-seq-workflow-2021
========================================

This document is written to allow anyone to use the RNA-seq analysis workflow I used in my MSc project.

You can run this workflow on your local computer or on a high performance computer
if you have access to one.

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

Downloading RNA-seq data
----------------------
You now have your new conda envrionment set up. We need to make a directory and download some FASTQ data to analyse.
Use the following commands to do this:

`mkdir FASTQ_data`

`wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/001/SRR3437051/SRR3437051_1.fastq.gz`

`wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR343/001/SRR3437051/SRR3437051_2.fastq.gz`

For now, there is no reason to worry about where these URLs came from, the wget commands should not take long to run (1-5 minutes depending on internet speed).
Once they have finished running, you can move on to the next step.

Running FASTQC
----------------------

Firstly, we need to run FASTQC to check the quality of the data we have. To do this, you need to be in the FASTQ_data directory (where your FASTQ files are located).

Before we run FASTQC we can make a new directory for the fastqc output files. Type `mkdir QC` to make a new directory.

Run this command:  `fastqc *fastq.gz -o QC` The `*` flag is a shortcut which allows us to run fastqc on all fastq.gz files within our current directory. The `-o` option allows us to direct the output of fastqc into the QC directory we just created.

You can view the fastqc output files by viewing the following files which are now located in the QC directory: SRR3437051_1_fastqc.html  SRR3437051_2_fastqc.html.

Running fastp
----------------------

To improve the quality of your FASTQ data, we can use pre processing algorithms (such as fastp) to remove low quality reads from the FASTQ data.

To run fastp on the pair of read files, run the following commands from the FASTQ_data directory:

Make an output directory for the ouput files:

`mkdir processed_reads`

Run fastp:

`fastp -i SRR3437051_1.fastq.gz -I SRR3437051_2.fastq.gz -o processed_reads/SRR3437051_1.fastq.gz -O processed_reads/SRR3437051_2.fastq.gz --detect_adapter_for_pe -c`

The `-i` and `-I` options are used to specify the first read and the second read in the pair. The `-o` option does the same and specifies the output directory. The `--detect_adapter_for_pe` option enables the automatic detection (and removal) of adapter sequences. The `-c` option is a base correction option which can be used on paired end data only.

We can now remove the original FASTQ files. To do this, check you are in the FASTQ_data directory and use the following command:

`rm *fastq.gz`

Running salmon
----------------------
(WIP)
