#!/bin/bash
#This script requries tophat2, samtools, intersectBed and Trinity in /usr/bin/
#Execution: ./Method2.sh reads1.fq reads2.fq TCRA_C.bed TCRB_C.bed out_dir
#Do NOT add / after out_dir when you call Method2.sh


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

$TOPHAT -r 210 --mate-std-dev 30 -m 2 --solexa-quals -o $5/out/tophat_run -p 8 $ENSEMBL $1 $2
#samtools import /home/simone/scRNA_Seq/Ensembl/Bowtie2Index/genome.fa.fai $5/out/tophat_run/accepted_hits.sam $5/out/tophat_run/accepted_hits.bam

#====== TRB only BEGIN =========
intersectBed -wa -abam $5/out/tophat_run/accepted_hits.bam -b $4 > $5/out/tophat_run/overlapping_reads.bam 
samtools view -h -o $5/out/tophat_run/overlapping_reads.sam $5/out/tophat_run/overlapping_reads.bam
cat $5/out/tophat_run/overlapping_reads.sam | grep -v ^@ | awk '{print "@"$1"\n"$10"\n+\n"$11}' > $5/overlapping_reads.fq
cat $5/overlapping_reads.fq | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > $5/overlapping_reads.fa

grep ">" $5/overlapping_reads.fa > $5/overlapping_readsID.fa
sed 's\>\\g' $5/overlapping_readsID.fa > $5/overlapping_readsID3.txt
grep $1 -f $5/overlapping_readsID3.txt -A 3 -F > $5/out1b.fastq
grep $2 -f $5/overlapping_readsID3.txt -A 3 -F > $5/out2b.fastq

$trinitypath --left $5/out1b.fastq --right $5/out2b.fastq --seqType fq --max_memory 10G --output $5/trinity_out_dir

mv $5/trinity_out_dir/Trinity.fasta $5/tcr_b.fa
rm -r $5/trinity_out_dir
rm $5/overlapping_reads*

#====== TRB only END =========

#====== TRA only BEGIN =========
intersectBed -wa -abam $5/out/tophat_run/accepted_hits.bam -b $3 > $5/out/tophat_run/overlapping_reads.bam 
samtools view -h -o $5/out/tophat_run/overlapping_reads.sam $5/out/tophat_run/overlapping_reads.bam
cat $5/out/tophat_run/overlapping_reads.sam | grep -v ^@ | awk '{print "@"$1"\n"$10"\n+\n"$11}' > $5/overlapping_reads.fq
cat $5/overlapping_reads.fq | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > $5/overlapping_reads.fa

grep ">" $5/overlapping_reads.fa > $5/overlapping_readsID.fa
sed 's\>\\g' $5/overlapping_readsID.fa > $5/overlapping_readsID3.txt
grep $1 -f $5/overlapping_readsID3.txt -A 3 -F > $5/out1a.fastq
grep $2 -f $5/overlapping_readsID3.txt -A 3 -F > $5/out2a.fastq

$trinitypath --left $5/out1a.fastq --right $5/out2a.fastq --seqType fq --max_memory 10G --output $5/trinity_out_dir

mv $5/trinity_out_dir/Trinity.fasta $5/tcr_a.fa
rm -r $5/trinity_out_dir
rm $5/overlapping_reads*

#====== TRA only END =========

#rm -r $5/out






