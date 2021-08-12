# DESeq2 differential gene expression analysis code

library(BiocManager)
library(DESeq2)
library(readr)
library(dplyr)
library(magrittr)
library(tximport)

# read in run table from SRA
run_table = read_csv('processed_reads/SraRunTable.txt')


# count files for tximport
sample_ids = pull(run_table, Run)
count_files = paste0('processed_reads/',sample_ids, '/quant.sf')

# read in mapped transcripts file
transcripts_mapped = read_csv('processed_reads/gene_map.csv',
                              col_names = c("Gene_ID","Transcript_ID"))

# read in read count data using tximport
count_data = tximport(files = count_files, type='salmon',
                          ignoreTxVersion = TRUE, tx2gene = transcripts_mapped)

# import data into DESeq2
deseq_data = DESeqDataSetFromTximport(txi = count_data, colData = 
                                      run_table, design = ~progression_step)

# run DESeq2 analysis on data
dds = DESeq(deseq_data)

# get results
dds_results = results(dds , contrast = c("progression_step","CaP","BPH"))

# check each gene for differential expression
dds_results$dif_exp = dds_results$padj < 0.05 & abs(dds_results$log2FoldChange) > 1
dds_dif_exp_results = data.frame(dds_results)

# use dplyr to filter dataframe for differentially expressed genes only
dds_dif_exp_results = filter(dds_dif_exp_results, padj < 0.05)
dds_dif_exp_results = filter(dds_dif_exp_results, abs(log2FoldChange) > 1)

# MA plot
plotMA(dds , alpha = 0.01, main = "MA plot")

# PCA plot
dds_var_transform = varianceStabilizingTransformation(deseq_data)
plotPCA(dds_var_transform , intgroup = 'progression_step')
