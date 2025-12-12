## General information

- Title: 16S Data Processing with Cutadapt & DADA2 for Rumen Microbiome Analysis
- Author: Anna kolganova
- Date: 2025-11-30
- Environment: Pitzer cluster at OSC via VS Code
- Working dir: `/fs/ess/PAS2880/users/kolganovaanna/FinalProject`

## Assignment background

This is a final project progress report focusing on analyzing 16S sequencing data obtained by processing rumen fluid samples. 

## Goal and objectives

Goal: To process 16S sequencing data and generate high-quality microbial community profiles from rumen samples.

Objectives:

1. Explore microbial community composition
2. Remove low-quality reads and adapters

## Protocol

**Part A**: Obtaining and describing samples 

1. Study selection and description

I obtained samples from the study proposed and found by Menuka: [research paper](https://academic.oup.com/ismej/article/16/11/2535/7474101#435086839). This study focuses on exploring metabolically distinct microorganisms found in the rumen microbiota of 24 beef cattle. I was interested in the study because I work with ruminal microbiome in the scope of my Ph.D. research. Analyzing such datasets can help me work on my own data in the future. 


2. Obtaining specific samples

I chose samples #1 (run SRR14784363) and #14 (run SRR14784377). I obtained reverse and forward reads for these samples using this website: [SRA Explorer](https://sra-explorer.info/#). These commands worked for me:

```bash
#!/usr/bin/env bash
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR147/063/SRR14784363/SRR14784363_1.fastq.gz -o SRR14784363_AMPLICON_of_rumen_cattle_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR147/063/SRR14784363/SRR14784363_2.fastq.gz -o SRR14784363_AMPLICON_of_rumen_cattle_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR147/077/SRR14784377/SRR14784377_1.fastq.gz -o SRR14784377_AMPLICON_of_rumen_cattle_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR147/077/SRR14784377/SRR14784377_2.fastq.gz -o SRR14784377_AMPLICON_of_rumen_cattle_2.fastq.gz
```


3. Run descriptions

* Run SRR14784363

This run consists of 99.44% identified reads and 0.56% unidentified reads. Out of the 99.44%, domain Bacteria composes 99.24% and domain Archaea contributes only 0.15%. The length of each read is 250. Learn more about the run using this link: [SRR14784363](https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&page_size=10&acc=SRR14784363&display=metadata)

* Run SRR14784377

This run consists of 97.83% identified reads and 2.17% unidentified reads. Out of the 97.83%, domain Bacteria composes 96.80% and domain Archaea contributes only 0.95%. The length of each read is 250. Learn more about the run using this link: [SRR14784377](https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&page_size=10&acc=SRR14784377&display=metadata)

The first run contains substantially fewer Archaea compared to the second run, while the second run also has slightly fewer Bacteria. 

**Part B**

4. Project structure

To structurize the project, I created a couple of directories within FinalProject:

```bash
touch Main_Protocol.md Notes.md
mkdir data results scripts
```
File "Main_Protocol.md" is the central document of the project, describing steps used in this project, their sugnificance, and outputs. File "Notes.md" contains the same information but has detailed housekeeping commands, in case more information is needed to explain how and what I did in the main .md. 
'Data' directory within FinalProject contains analyzed data files with inittial reverse and forward reads as well as datasets added during protocol execution. 'Results' directory contains output files for commands used in the protocol. 'Scripts' directory contains code scripts used throughout the project. 

A Git repository was initialized after all of the initial dirs are made:

```bash
git init
git add Main_Protocol.md Notes.md
git commit -m "Committing to main_protocol and notes to set up"
echo "results/" > .gitignore
echo "data/" >> .gitignore
git add .gitignore
git commit -m "Adding a Gitignore file"
```

**Note**: files that should be ignored in this working directory are ProgressReport and ProjectProposal. They are kept in the dir to only serve as the background for the project. 

5. General analysis of the reads

The purpose of the step is to gather some general data on my files. These data include  file size, total number of lines, and the number of gemonic features. In the main protocol, I will show commands I used only for SRR14784363_1.fastq.gz sample to practically illustrate how I gathered these general information for all of my runs. 

To obtain sample size I used this command:

```bash
gunzip data/SRR14784363/SRR14784363_1.fastq.gz
ls -lh data/SRR14784363/SRR14784363_1.fastq
```

To count the number of lines, I used this command:

```bash
wc -l data/SRR14784363/SRR14784363_1.fastq 
```

To count the number of genomic features, I used this command:

```bash
grep -v "^@" data/SRR14784363/SRR14784363_1.fastq | wc -l
```

I created .txt files with obtained general information for each of my samples under 'results/'. Below are the commands I used specifically for SRR14784363_1.fastq:

```bash
echo "File size:" >> results/SRR14784363/r1_general_info.txt
ls -lh  data/SRR14784363/SRR14784363_1.fastq  >> results/SRR14784363/r1_general_info.txt
echo "Total lines:" >> results/SRR14784363/r1_general_info.txt
wc -l data/SRR14784363/SRR14784363_1.fastq  >> results/SRR14784363/r1_general_info.txt
echo "Reads(no headers):" >> results/SRR14784363/r1_general_info.txt
grep -v "^@"  data/SRR14784363/SRR14784363_1.fastq | wc -l  >> results/SRR14784363/r1_general_info.txt
```
I used the same commands for my ther 3 files (check Notes.md). According to the results, we can say that these samples are pretty similar in size and number of reads. 

6. Taking a closer look at the samples

In order to get a better understanding of the contents of my files, I want to print specific lines from them and store these output lines as separate files under 'results/'. In order for this to happen, I first created the script and saved it under 'scripts/lines.sh'. This script shows first and last reads (each read = 4 lines). 

Now, we will look how the script was run for my files:

```bash
bash scripts/lines.sh  data/SRR14784363/SRR14784363_1.fastq  > results/SRR14784363/printed_lines_f1.txt
bash scripts/lines.sh  data/SRR14784363/SRR14784363_2.fastq  > results/SRR14784363/printed_lines_r1.txt
bash scripts/lines.sh  data/SRR14784377/SRR14784377_1.fastq  > results/SRR14784377/printed_lines_f2.txt
bash scripts/lines.sh  data/SRR14784377/SRR14784377_2.fastq  > results/SRR14784377/printed_lines_r2.txt
```
Produced outputs were stored in separate .txt files under 'results/'. Let's look at the output for SRR14784377_1.fastq:

```bash
First read in data/SRR14784363/SRR14784363_1.fastq:
@SRR14784363.1 1/1
CTACGTACCTACGGGATGCAGCAGTAGGGAATATTGCACAATGGAGGGAACTCTGATGCAGCCATGCCGCGTGTGTGAAGAAGGCCTTCGGGTTGTAAAGCACTTTAGTTTTCGAGAAAGGGTGCAATTCGAACAGGGTTGTATTCAGATGTTAGAAAAAGAATAAGTACCGGCAAACTCCGTGCCAGCAGCCGCGGTAATACGGAGGGTACGAGCGTTAATCGGAATGACTGGGCGTAAAGGGCACGTA
+
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,FFFFFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFFFFFFFFFFFFFF,:FFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFF:F

Last read in data/SRR14784363/SRR14784363_1.fastq:
@SRR14784363.74229 74229/1
CTACGTACCTATGGGATGCAGCAGTGGGGGATATTGCGCAATGGGGGAAACCCTGACGCAGCAACGCCGCGTGGAGGATGACGGTTTTCGGATTGTAAACTCCTTTTATGGGGGACGAATCAAGACGGTACCCCATGAATAAGCTCCGGCTAACTACGTGCCAGCAGCCGCGGTAATACGTAGGGAGCAAGCGTTGTCCGGATTTACTGGGTGTAAAGGGTGCGTAGGCGGCTTGGTAAGTCAGATGTGA
+
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,F,FFFFFFFFFFFFFFFF,FFFF:FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,FFFFFFF:FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFFFFFFFF:FFFFFFFFFFFF:FFFFFFFF,FFFFF:FFF:FFFFF:FFF
```
Let's talk about the quality scores first to have some understanding of the reads. Fs stand for high-quality base, ":" stand for relatively good quality, and "," low quality scores. Most of my reads are of high quality but there are some that are low-quality. These are the reads I am targeting in the project. 


*Git commit*:
```bash
git add scripts/*.sh Main_Protocol.md Notes.md
git commit -m "Part B"
```

**Part C**

7. Using Cutadapt to exclude primer sequences

Because my samples were generated using metabarcoding, each read contains primer sequences that are identical across all reads. To prevent inaccuracies that these primer sequences could introduce into downstream analyses, the primers must be removed before further processing. For this step, I used Cutadapt.

First, primer sequences need to be identified and stored as variables:

```bash
primer_f=CCTAYGGGRBGCASCAG
primer_r=GGACTACNNGGGTATCTAAT
```

We know that DNA is double-stranded. One strand is the forward sequence. The other is the reverse complement. Therefore, next, we need to get the reverse complement of our primer sequences:

```bash
primer_f_rc=$(echo "$primer_f" | tr ATCGYRKMBDHV TAGCRYMKVHDB | rev)
primer_r_rc=$(echo "$primer_r" | tr ATCGYRKMBDHV TAGCRYMKVHDB | rev)

# Checking the sequences
echo "$primer_f_rc"
echo "$primer_r_rc"
```

The outputs were:

```bash
CTGSTGCVYCCCRTAGG
ATTAGATACCCNNGTAGTCC
```

Next, we I wrote scripts for our files under 'scripts/cutadapt1.sh' (for SRR14784363) and 'scripts/cutadapt2.sh' (For SRR14784377).Let's see how the script worked for the samples:

```bash
sbatch scripts/cutadapt1.sh
sbatch scripts/cutadapt2.sh

squeue -u kolganovaanna -l
```

The outputs were:

```bash
Submitted batch job 42403284
Mon Dec 08 14:32:02 2025
JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
42403284       cpu cutadapt kolganov  RUNNING       0:01     30:00      1 p0016
42397559       cpu ondemand kolganov  RUNNING    1:59:59   3:00:00      1 p0020
42397553   cpu-exp ondemand kolganov  RUNNING    2:00:36   3:00:00      1 p0840

Submitted batch job 42403302
Mon Dec 08 14:34:16 2025
JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
42397559       cpu ondemand kolganov  RUNNING    2:02:11   3:00:00      1 p0020
42403302 cpu,cpu-e cutadapt kolganov  PENDING       0:00     30:00      1 (Reservation)
42397553   cpu-exp ondemand kolganov  RUNNING    2:02:48   3:00:00      1 p0840
```
**Note**: the commands run really fast so I couldn't catch the second slurm batch job running. However, my .err files had no content and .out files indicated that the scripts were run successfully. I also had no FAIL emails.

The output files include a summary of how the script processed the reads. Almost all of the reads contained the adapters. Nearly all reads were trimmed and passed through Cutadapt. Let's do one final check of the outputs using these commands:

Checking the output: 

```bash
grep "with adapter:" slurm-cutadapt63.out
grep "with adapter:" slurm-cutadapt77.out
```

```bash
  Read 1 with adapter:                  74,032 (99.7%)
  Read 2 with adapter:                  72,436 (97.6%)

  Read 1 with adapter:                  71,904 (99.9%)
  Read 2 with adapter:                  71,840 (99.8%)
```

We see that the percentages of reads that contained adapters is in the upper 90s, which can tell us that there's likely nothing wrong with the adapter sequences I provided or with Cutadapt syntax. 

I moved the produced files into 'results/slurm' directory using this command:

```bash
cp *slurm-cutadapt*.out *slurm-cutadapt*.err results/slurm/
```

*Git commit*:
```bash
git add scripts/*.sh Main_Protocol.md Notes.md
git commit -m "Part C"
```

8. DADA2 Pipline Construction 

DAD2 pipeline can help characterize microbiome composition. R Protocol for DADA2 can be found in this directory, in the DADA2.qmd file. You can also take a look at the rendered DADA2.html file. 

In order to have R access my cutadapt files easily, I created a 'data/cutadapt_combined' directory and copied all cutadapt fastq files into it.  

Before starting with R, I went into Cluster -> Pitzer Shell Access and used this command:

```bash
cp -rv /fs/ess/PAS2880/users/kolganovaanna/FinalProject/data/cutadapt_combined /fs/ess/PAS2880/users/$USER/
```

**Note**: I am going to take my results folder out of .gitignore because I wangt you to be able to see all the graphs and slurm outputs.

**Conclusions**

According to the analysis, a good number of reads successfully passed all processing steps. I was able to generate a high-quality microbial community profile, which told me that Bacteroidota and Firmicutes are most abundant microbes in my samples. These taxonomic groups are actually very common in the rumen, which makes me more confident in the quality of my dada2 pipeline. 
Cutadapt and DADA2 are useful tools for amalyzing 16S sequencing data.
I didn't have time to develop this project any further (got sick) but I am planning to practice alpha and beta diversity in R over the break. This practice is a great opportunity for me to prepare for my own sequencing data analysis in the near future. 
I believe I completed both course surveys. 

*Git commit*:
```bash
git add Main_Protocol.md Notes.md DADA2.html DADA2.qmd -f results
git commit -m "Final Commit"
git remote add origin git@github.com:kolganovaanna/Final-Project-.git
git branch -M main
git push -u origin main
```
