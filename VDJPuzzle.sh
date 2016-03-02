#!/bin/bash
#Source code implemented by Simone Rizzetto (UNSW, Australia), for enquiries and documentation please refer to https://github.com/Simo-88/VDJPuzzle

#SET DEFAULT PARAMETERS
PARALLEL=0
RUNTCR=1
RUNR=1
NTHREADS=1

#PARSING PARAMETERS
for i in "$@"
do
	case $i in
	    -h|--help)
	    echo "VDJ Puzzle v1.0"
	    echo "Usage: run_tcr.sh directory_name [option]"
	    echo "--CPU\tnumber of processes"
	    echo "--THR\tnumber of threads to use for each process"
	    echo "--only-statistics\texecutes only summary statistics script"
	    echo "--no-statistics\tdo not executes summary statistics script"
	    exit 0
	    shift
	    ;;
	    --CPU=)
	    PARALLEL="${i#*=}"
	    shift 
	    ;;
	    --only-statistics)
	    RUNTCR=0
	    shift 
	    ;;
	    --no-statistics)
	    RUNR=0
	    shift 
	    ;;
	    *)
	    echo "SC_RNA_SEQ Directory $i"
	    RNADIR=$i
	    ;;

	esac
done

if [ "$PARALLEL" -gt 1 ]; then
	echo "Running VDJ Puzzle in parallel mode with $PARALLEL processes."
else
	echo "Running VDJ Puzzle with a single process."
fi

#MAKE SURE TO HAVE THE ABSOLUTE PATH WITHOUT / AT THE END
CURDIR=$PWD
cd $RNADIR
RNADIR=$PWD
cd $CURDIR

#PART1 - GENERATE PRELIMINARY VDJ REPERTOIRE
for d in $RNADIR/*
do
	echo $d
	di=${d%%/};
	echo $di
	nfiles=$(find $di/*.fastq* -type f | wc -l)
	if [ "$nfiles" -ge 2 ]; then
		if [ "$(ls -A $di)" ]; then
			FILES=$di/*_L00*
			for f in $FILES
			do
				filename="${f##*/}"
				IND=$(expr match "$filename" ".*_L00")
				filename=${filename:0:$IND}
			done
		else
		    echo "$DIR contains less than two files."
		fi
		if [ "$PARALLEL" -gt 1 ]; then
			for np in { 1..$PARALLEL } 
			do 
				./run_tcr_method2_sc_1file.sh $di $filename &
			done
			wait
		else
			./run_tcr_method2_sc_1file.sh $di $filename
		fi
	fi
done

wait

rm -r preliminary
mkdir preliminary
mv VDJ_p1* preliminary/

echo "Preliminary TCR repertoire reconstructed."

#PART2 - BUILD A NEW REFERENCE GENOME BASED ON THE PRELIMINARY REPERTOIRE
rm all_sequences_a.fa
rm all_sequences_b.fa

for d in preliminary/*
do
	echo $d
	di=${d%%/};
	echo $di
	nfiles=$(find $di/*.fastq* -type f | wc -l)
	if [ "$nfiles" -ge 2 ]; then
		if [ "$(ls -A $di)" ]; then
			FILES=$di/*_L00*
			for f in $FILES
			do
				filename="${f##*/}"
				IND=$(expr match "$filename" ".*_L00")
				filename=${filename:0:$IND}
			done
		else
		    echo "$DIR contains less than two files."
		fi
		if [ "$PARALLEL" -gt 1 ]; then
			for np in { 1..$PARALLEL }
			do 
				./run_tcr_method2_sc_part2.sh $di $filename &
			done
			wait
		else
			./run_tcr_method2_sc_part2.sh $di $filename
		fi
	fi
done

wait

bowtie2-build -f all_sequences_a.fa TCRA
bowtie2-build -f all_sequences_b.fa TCRB

mkdir assembledTCR_genome
mv *.bt2 assembledTCR_genome/

#PART3 - 
for d in $RNADIR/*
do
	echo $d
	di=${d%%/};
	echo $di
	nfiles=$(find $di/*.fastq* -type f | wc -l)
	if [ "$nfiles" -ge 2 ]; then
		if [ "$(ls -A $di)" ]; then
			FILES=$di/*_L00*
			for f in $FILES
			do
				filename="${f##*/}"
				IND=$(expr match "$filename" ".*_L00")
				filename=${filename:0:$IND}
			done
		else
		    echo "$DIR contains less than two files."
		fi
		if [ "$PARALLEL" -gt 1 ]; then
			for np in { 1..$PARALLEL }
			do 
				./run_tcr_method2_sc_1file_part3.sh $di $filename &
			done
			wait
		else
			./run_tcr_method2_sc_1file_part3.sh $di $filename
		fi
	fi
done

wait

rm -r TCRsequences
mkdir TCRsequences
mv VDJ_p3* TCRsequences/

if [ "$RUNR" -ge 1 ]; then
	cat summary/TRA* > summary/h1.txt
	cat summary/TRB* > summary/h2.txt
	head -1 summary/h1.txt > summary/header1.txt
	head -1 summary/h2.txt > summary/header2.txt
	rm summary/TRAtmp.txt
	rm summary/TRBtmp.txt
	rm summary/TRA_cells.txt
	rm summary/TRB_cells.txt
	rm summary/TRA.csv
	rm summary/TRB.csv

	for tcr in summary/TRA*;
	do
		if [ "$(cat $tcr | wc -l)" -ge 3 ]; then
			echo ${tcr##*/} >> summary/TRA_cells.txt
			echo ${tcr##*/} >> summary/TRA_cells.txt
			cat $tcr | head -3 | tail -2 >> summary/TRAtmp.txt
		elif [ "$(cat $tcr | wc -l)" -ge 2 ]; then
			echo ${tcr##*/} >> summary/TRA_cells.txt
			cat $tcr | head -2 | tail -1 >> summary/TRAtmp.txt
		fi
	done

	for tcr in summary/TRB*;
	do	
		if [ "$(cat $tcr | wc -l)" -ge 3 ]; then
			echo ${tcr##*/} >> summary/TRB_cells.txt
			echo ${tcr##*/} >> summary/TRB_cells.txt
			cat $tcr | head -3 | tail -2 >> summary/TRBtmp.txt
		elif [ "$(cat $tcr | wc -l)" -ge 2 ]; then
			echo ${tcr##*/} >> summary/TRB_cells.txt
			cat $tcr | head -2 | tail -1 >> summary/TRBtmp.txt
		fi
	done

	cat summary/header1.txt summary/TRAtmp.txt > summary/single_cells_TRA.txt
	cat summary/header2.txt summary/TRBtmp.txt > summary/single_cells_TRB.txt
	echo "CellID" > summary/single_cells_ID_TRA.txt
	echo "CellID" > summary/single_cells_ID_TRB.txt
	cat summary/TRA_cells.txt >> summary/single_cells_ID_TRA.txt
	cat summary/TRB_cells.txt >> summary/single_cells_ID_TRB.txt
	paste -d"\t" summary/single_cells_ID_TRA.txt summary/single_cells_TRA.txt > summary/TRA.csv
	paste -d"\t" summary/single_cells_ID_TRB.txt summary/single_cells_TRB.txt > summary/TRB.csv
	rm summary/h1.txt
	rm summary/h2.txt
	rm summary/header1.txt
	rm summary/header2.txt
	rm summary/TRAtmp.txt
	rm summary/TRBtmp.txt
	rm summary/TRA_cells.txt
	rm summary/TRB_cells.txt
	rm summary/single_cells_TRA.txt
	rm summary/single_cells_TRB.txt
	rm summary/single_cells_ID_TRA.txt
	rm summary/single_cells_ID_TRB.txt
fi

echo "TCR identification completed! Check your results in the summary directory."


