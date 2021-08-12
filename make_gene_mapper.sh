#!/usr/bin/bash

# get transcripts
cat gencode.v38.transcripts.fa | grep -P -o "ENST\d{11}" > transcripts.txt

# get genes
cat gencode.v38.transcripts.fa | grep -P -o "ENSG\d{11}" > genes.txt

# merge transcripts and genes
paste -d ',' transcripts.txt genes.txt > gene_map.csv
