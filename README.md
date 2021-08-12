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

Quality control (QC)
----------------------

Firstly, we need to run FASTQC to check the quality of the data we have. To do this, you need to be in the FASTQ_data directory (where your FASTQ files are located).

Before we run FASTQC we can make a new directory for the fastqc output files. Type `mkdir QC` to make a new directory.

Run this command:  `fastqc *fastq.gz -o QC` The `*` flag is a shortcut which allows us to run fastqc on all fastq.gz files within our current directory. The `-o` option allows us to direct the output of fastqc into the QC directory we just created.

You can view the fastqc output by viewing the following files which are now located in the QC directory: `SRR3437051_1_fastqc.html` and `SRR3437051_2_fastqc.html`.

To view the FASTQC reports in a single report, we can use multiqc.

To run multiqc, use the following command: `multiqc QC`

This will create a file called `multiqc_report.html` which you can view.

Running fastp (pre-processing)
----------------------

To improve the quality of your FASTQ data, we can use pre processing algorithms (such as fastp) to remove low quality reads from the FASTQ data.

To run fastp on the pair of read files, run the following commands from the FASTQ_data directory:

Make an output directory for the ouput files:

`mkdir processed_reads`

Run fastp:

`fastp -i SRR3437051_1.fastq.gz -I SRR3437051_2.fastq.gz -o processed_reads/SRR3437051_1.fastq.gz -O processed_reads/SRR3437051_2.fastq.gz --detect_adapter_for_pe -c`

The `-i` and `-I` options are used to specify the first read and the second read in the pair. The `-o` and `-O` options do the same and specify the output directory. The `--detect_adapter_for_pe` option enables the automatic detection (and removal) of adapter sequences. The `-c` option is a base correction option which can be used on paired end data only.

We can now remove the original FASTQ files. To do this, check you are in the FASTQ_data directory and use the following command:

`rm *fastq.gz`

Running salmon (read quantification)
----------------------
Salmon is a read quantification algorithm which performs quantification at the transcript level via a pseudo alignment algorithm. Therefore, salmon requires the human transcriptome before it can be used in it's quantification mode.

Change into the processed_reads directory: `cd processed_reads`

To download the human transcriptome use the following command ` wget http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.transcripts.fa.gz`

Now that we have the human transcriptome, we can build the index which salmon requires to perform read quantification:

`salmon index -t ./gencode.v38.transcripts.fa.gz -i human_v38_index --gencode`

The `-t` option specifies where the human transcriptome is located (`./` refers to current directory). The `-i` option specifies the name of the salmon index. The `--gencode` option is used as we are using the gencode transcriptome in this workflow. This command will take a few minutes to run.

Now that the index has been built, we can run salmon in it's quantification mode to quantify our reads. To do this, run the following command:

`salmon quant -i human_v38_index -l A -1 SRR3437051_1.fastq.gz -2 SRR3437051_2.fastq.gz -o read_counts`

The `-i` option is to specify the location of the index we just built. The `-l` option is set to `A` to allow salmon to automatically detect the RNA-seq library type. The `-1` and `-2` options are used to specify the first and second read pairs. The `-o` option is used to specify an output directory. Your quantification files will be in the `read_counts` directory. Try running `ls read_counts` to see the salmon output files, the quant.sf file is the file which countains the read count data.

Running DESeq2 (Differential expression analysis)
----------------------
To perform a differential expression analysis, we need two different samples to compare. Therefore, we need to run the read quantification workflow on another sample. To do this, use the commands in the workflow.sh script provided in the repo.

Once you have ran the workflow.sh script you should have two quant.sf files in the processed_reads directory. The CaP sample quant.sf file is in the read_counts directory, the BPH sample quant.sf file is in the read_counts_2 directory

