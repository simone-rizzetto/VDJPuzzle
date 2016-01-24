#!/bin/bash
#This script needs tophat2, samtools, intersectBed and trinity in /usr/bin/
#Requires the fasta converter script provided with VDJSeq-Solver (http://eda.polito.it/VDJSeq-Solver/index.html)
#Execution: ./Method2.sh reads1.fq reads2.fq TCRA_C.bed TCRB_C.bed out_dir
#Do NOT add / after out_dir when you call Method2.sh

trinitypath=/home/simone/Tools/trinityrnaseq_r20140717/Trinity
BOWTIE=bowtie2

rm $5/overlapping_reads*
rm $5/out1b.fastq
rm $5/out2b.fastq
rm $5/out1a.fastq
rm $5/out2a.fastq


mkdir $5

rm $5/overlapping_reads*
rm $5/out1b.fastq
rm $5/out2b.fastq
rm $5/out1a.fastq
rm $5/out2a.fastq

mkdir $5/out


$BOWTIE --no-unal -p 8 -k 1 --np 0 --rdg 1,1 --rfg 1,1 -x assembledTCR_genome/TCRB -1 $1 -2 $2 --al-conc $5/reads_TCRB_%.fastq -S TCRB.sam
$BOWTIE --no-unal -p 8 -k 1 --np 0 --rdg 1,1 --rfg 1,1 -x assembledTCR_genome/TCRA -1 $1 -2 $2 --al-conc $5/reads_TCRA_%.fastq -S TCRA.sam

$trinitypath --JM 1G --seqType fq --CPU 8 --full_cleanup --left $5/reads_TCRB_1.fastq --right $5/reads_TCRB_2.fastq -o $5/trinity_out_dir
mv $5/trinity_out_dir.Trinity.fasta $5/tcr_b.fa
rm -r $5/trinity_out_dir


$trinitypath --JM 1G --seqType fq --CPU 8 --full_cleanup --left $5/reads_TCRA_1.fastq --right $5/reads_TCRA_2.fastq -o $5/trinity_out_dir
mv $5/trinity_out_dir.Trinity.fasta $5/tcr_a.fa
rm -r $5/trinity_out_dir





