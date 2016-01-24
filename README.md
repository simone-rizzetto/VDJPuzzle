<<<<<<< HEAD
<h1>VDJ Puzzle</h1>

VDJ Puzzle [<a href="#Ref1">1</a>] is a method to build T-Cell Receptor and B-Cell Receptor assembly from single cell RNA sequencing data.

<h2>Requiraments</h2>
VDJ Puzzle requires the following tools:
<ul>
<li><a href="">TopHat2</a> for alignament;</li>
<li><a href="">Trinity2</a> for denovo assembly of TCR;</li>
<li><a href="">Ensembl GHRC37</a> as refernce genome, but it can be easily adapted to other reference genomes (<a href="#generateBED">here</a> it is explained how);</li>
<li><a href="https://github.com/mikessh/migmap">MiGMAP v0.9.7</a> to build a detailed information table (incoroporates IgBlast);</li>
<li><a href="">Java 1.8</a> is required by MiGMAP;</li>
<li>[optional] R with <a href="">tcR package</a> to generate plots and summary statistics of the clonotype;</li>
</ul>
<h2>Installation</h2>
To install VDJ Puzzle is sufficient to unzip it in a folder and update the paths to the required softwares:
In file 
```bash
MIGMAP=/path_to_migmap/migmap(version).jar
```

```bash
trinitypath=/path_to_trinity/Trinity
```

<h2>Usage</h2>

```bash
./run_tcr.sh directory_name [options]
```

<h2>Additional Information</h2>

<a name="generateBED"></a><h3>How to generate new BED files for different reference genomes</h3>
If you want to use a different reference genome you need to generate new BED files containing the position of the constant segment transcripts.

<b>Method 1:</b>
```bash
grep "TRAC" genes.gtf > TRAC.csv
grep "TRAV" genes.gtf > TRAV.csv
grep "TRAJ" genes.gtf > TRAJ.csv
cat TRAC.csv TRAV.csv TRAJ.csv > TRA.csv
```
edit TRA.csv in order to have a table with <i>chromosome</i>{tab}<i>starting position</i>{tab}<i>ending position</i> for each TRA gene and rename the file as "TRA.bed". Repeat for TRB adding the command
```bash
grep "TRBD" genes.gtf > TRBD.csv
```

<b>Method 2:</b>

<u>Finally, you need to update the position of the new BED files in run_sc.sh</u>
```bash
TCRA=/path_to_bed_files/TRA.bed
TCRB=/path_to_bed_files/TRB.bed
```

<h2>Example</h2>
We provide some example files to test VDJPuzzle. These sequences are a subset of two  cells part of the dataset used in [<a href="#Ref1">1</a>] (Link to dataset cooming soon).<br>
from VDJPuzzle directory
```bash
./VDJPuzzle.sh Example
```

<h2>Further Questions?</h2>
You can post any question or issue to our <a href="https://groups.google.com/forum/#!forum/vdj-puzzle">Google group</a>
<br>
or by email ( s.rizzetto at student.unsw.edu.au )

<h2>Cite us</h2>
VDJPuzzle paper is currently under review. In the meantime you can cite VDJPuzzle with <br>
[<a name="Ref1">1</a>] Auda Eltahla\*, Simone Rizzetto\*, Mehdi Rasoli\*, Brigid Betz-Stablein, Vanessa Venturi, Andrew R Lloyd, Katherine Kedzierska, Rowena A Bull and Fabio Luciani. (Date of download). VDJPuzzle. Downloaded from https://github.com/Simo-88/VDJPuzzle
=======
# VDJPuzzle
>>>>>>> 7ce1ad71e893b3b924cc27bf6c729e4a1ae2a6df
