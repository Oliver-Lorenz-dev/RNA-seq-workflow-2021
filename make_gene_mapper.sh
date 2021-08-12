#!/usr/bin/bash

cat gencode.v38.transcripts.fa | grep -P -o "ENST\d{11}" > transcripts.csv
cat gencode.v38.transcripts.fa | grep -P -o "ENSG\d{11}" > genes.csv
paste *.csv > gene_map.csv
