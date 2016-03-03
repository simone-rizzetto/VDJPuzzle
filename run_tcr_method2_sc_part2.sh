#!/bin/bash
#This script execut the RNA-Seq alingnamet pipeline sequentially, multithreading is implemented within the scripts (tophat and cufflinks)
#This script should be executed in parallel on different cells indicating the right directory ($1)

#parameters
#parameter one need to be the ABSOLUTE path where cell sequences are located WITHOUT /
CELL_PATH=$1


#unzip all files in a dir

$JAVA18 -jar $MIGMAP -S human -R TRA -S human --by-read $CELL_PATH/tcr_a.fa $CELL_PATH/ig_a.out
tail -n+2 $CELL_PATH/ig_a.out > $CELL_PATH/ig_a.tmp
cut -f1 $CELL_PATH/ig_a.tmp -d " " > $CELL_PATH/reads_a.txt
cut -c 2- $CELL_PATH/reads_a.txt | xargs -n 1 samtools faidx $CELL_PATH/tcr_a.fa > matching_reads_a.fa

$JAVA18 -jar $MIGMAP -S human -R TRB -S human --by-read $CELL_PATH/tcr_b.fa $CELL_PATH/ig_b.out
tail -n+2 $CELL_PATH/ig_b.out > $CELL_PATH/ig_b.tmp
cut -f1 $CELL_PATH/ig_b.tmp -d " " > $CELL_PATH/reads_b.txt
cut -c 2- $CELL_PATH/reads_b.txt | xargs -n 1 samtools faidx $CELL_PATH/tcr_b.fa > matching_reads_b.fa

cat matching_reads_a.fa >> all_sequences_a.fa
cat matching_reads_b.fa >> all_sequences_b.fa



