#!/bin/bash
#This script execut the RNA-Seq alingnamet pipeline sequentially, multithreading is implemented within the scripts (Trimmomatic, tophat and cufflinks)
#This script should be executed in parallel on different cells indicating the right directory ($1)

#parameters
#parameter one need to be the ABSOLUTE path where cell sequences are located WITHOUT /
CELL_PATH=$1

PREFIX=$2
SUFFIX=P.fastq.gz
R1=_R1_001
R2=_R2_001


#unzip all files in a dir
gunzip -f $CELL_PATH/*.fastq.gz
cat $CELL_PATH/*$R1* > $CELL_PATH/merged_R1.fastq
cat $CELL_PATH/*$R2* > $CELL_PATH/merged_R2.fastq

./Method2.sh $CELL_PATH/merged_R1.fastq $CELL_PATH/merged_R2.fastq $TCRA $TCRB VDJ_p1_$2

mkdir summary
$JAVA18 -jar $MIGMAP -S human -R TRA -S human VDJ_p1_$2/tcr_a.fa summary/TRA_$2
$JAVA18 -jar $MIGMAP -S human -R TRB -S human VDJ_p1_$2/tcr_b.fa summary/TRB_$2

rm $CELL_PATH/merged*
gzip $CELL_PATH/*.fastq


