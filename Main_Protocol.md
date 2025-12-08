## General information

- Title: Characterization of Rumen Microbiome via 16S Metabarcoding
- Author: Anna kolganova
- Date: 2025-11-30
- Environment: Pitzer cluster at OSC via VS Code
- Working dir: `/fs/ess/PAS2880/users/kolganovaanna/FinalProject`

## Assignment background

This is a final project progress report focusing on analyzing 16S sequencing data obtained by processing rumen fluid samples. 

## Goal and objectives
cp SRR14784363_1.fastq.gz data/SRR14784363/
cp SRR14784363_2.fastq.gz data/SRR14784363/


## Protocol

**Part A**: Obtaining and describing samples 

1. Study selection and description

I obtained samples from the study proposed and found by Menuka: [research paper](https://academic.oup.com/ismej/article/16/11/2535/7474101#435086839). This study focuses on exploring metabolically distinct microorganisms found in the rumen microbiota of 24 beef cattle. I was interested in the study because I work with ruminal microbiome in the scope of my Ph.D. research. Analyzing such datasets can help me work on my own data in the future. 


2. Obtaining specific samples

I obtain specific samples by searching PRJNA736529 project number (the study project number) on the NIH website: [datasets](https://www.ncbi.nlm.nih.gov/biosample?LinkName=bioproject_biosample_all&from_uid=736529)
I chose samples #1 (run SRR14784363) and #14 (run SRR14784377). 


3. Run descriptions

* Run SRR14784363

This run consists of 99.44% identified reads and 0.56% unidentified reads. Out of the 99.44%, domain Bacteria composes 99.24% and domain Archaea contributes only 0.15%. The length of each read is 250. Learn more about the run using this link: [SRR14784363](https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&page_size=10&acc=SRR14784363&display=metadata)

* Run SRR14784377

This run consists of 97.83% identified reads and 2.17% unidentified reads. Out of the 97.83%, domain Bacteria composes 96.80% and domain Archaea contributes only 0.95%. The length of each read is 250. Learn more about the run using this link: [SRR14784377](https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&page_size=10&acc=SRR14784377&display=metadata)

Menuka kindly helped me to download both forward and reverse reads ([obtaining reads](https://sra-explorer.info/)). I copied these files from this directory: '/fs/ess/PAS2880/users/menuka/Anna_help'. Each run corresponds to one biological sample, but it includes multiple files: the lite file plus the paired-end FASTQ files (_1 for forward reads and _2 for reverse reads).

The first run contains substantially fewer Archaea compared to the second run, while the second run also has slightly fewer Bacteria. Comparing the sequences from these two runs can provide insights into differences in the structure of their microbial populations. It is possible that some of the rumen fluid donors (the 24 beef cattle) are lower methane emitters than others due to variations in their microbiome composition, which is an interesting distinction to explore.

**Part B**

4. Project structure

To structurize the project, I created a couple of directories within FinalProject:

```bash
touch Main_Protocol.md Notes.md
mkdir data results scripts
```
File "Main_Protocol.md" is the central document of the project, describing steps used in this project, their sugnificance, and outputs. File "Notes.md" contains the same information but has detailed housekeeping commands, in case more information is needed to explain how and what I did in the main .md. 
'Data' directory withing FinalProject contains analyzed data files with reverse and forward reads. This directory is split into 2 subdierectories corresponding to the name of the samples I'm working with. 
'Results' directory is split into the same 2 subdirectories and contains output files for commands used in the protocol. 'Scripts' directory contains code scripts used throughout the project. 

A Git repositoryb was initialized after all of the initial dirs are made:

```bash
git init
git add Main_Protocol.md Notes.md
git commit -m "Committing to main_protocol and notes to set up"
echo "results/" > .gitignore
echo "data/" >> .gitignore
git add .gitignore
git commit -m "Adding a Gitignore file"
```

**Note**: files that should be ignored in this working directory are ProgressReport and ProjectProposal. 

5. General analysis of the reads

the purpose of the step is to gather some general data on my files. These data include  file size, total number of lines, and the number of gemonic features. In the main protocol, I will show commands I used only for SRR14784363.lite.1_1.fastq sample to practically illustrate how I gathered these general information for all of my runs. 

To obtain sample size I used this command:

```bash
ls -lh data/SRR14784363/SRR14784363.lite.1_1.fastq
```

To count the number of lines, I used this command:

```bash
wc -l data/SRR14784363/SRR14784363.lite.1_1.fastq 
```

To count the number of genomic features, I used this command:

```bash
grep -v "^@" data/SRR14784363/SRR14784363.lite.1_1.fastq | wc -l
```

I created .txt files with obtained general information for each of my samples under 'results/'. Below are the commands I used specifically for SRR14784363.lite.1_1.fastq:

```bash
echo "File size:" >> results/SRR14784363/r1_general_info.txt
ls -lh  data/SRR14784363/SRR14784363.lite.1_1.fastq  >> results/SRR14784363/r1_general_info.txt
echo "Total lines:" >> results/SRR14784363/r1_general_info.txt
wc -l data/SRR14784363/SRR14784363.lite.1_1.fastq  >> results/SRR14784363/r1_general_info.txt
echo "Reads(no headers):" >> results/SRR14784363/r1_general_info.txt
grep -v "^@"  data/SRR14784363/SRR14784363.lite.1_1.fastq | wc -l  >> results/SRR14784363/r1_general_info.txt
```
According to the results, we can say that these samples are pretty similar in size and number of reads. 

6. Taking a closer look at the samples

In order to get a better understanding of the contents of my files, I want to print specific lines from them and store these output lines as separate files under 'results/'. In order for this to happen, I first created the script and saved it under 'scripts/lines.sh'. This script shows first and last reads (each read = 4 lines). 

Now, we will look how the script was run for my files:

```bash
bash scripts/lines.sh  data/SRR14784363/SRR14784363.lite.1_1.fastq  > results/SRR14784363/printed_lines_f1.txt
bash scripts/lines.sh  data/SRR14784363/SRR14784363.lite.1_2.fastq  > results/SRR14784363/printed_lines_r1.txt
bash scripts/lines.sh  data/SRR14784377/SRR14784377.lite.1_1.fastq  > results/SRR14784377/printed_lines_f2.txt
bash scripts/lines.sh  data/SRR14784377/SRR14784377.lite.1_2.fastq  > results/SRR14784377/printed_lines_r2.txt
```
Produced outputs were stored in separate .txt files under 'results/'. Let's look at the output for SRR14784377.lite.1_1.fastq:

```bash
First read in data/SRR14784377/SRR14784377.lite.1_1.fastq:
@SRR14784377.lite.1.1 1 length=250
AGGATCCTACGGGACGCAGCAGTGAGGAATATTGGTCAATGGACGCAAGTCTGAACCAGCCAAGTAGCGTGAAGGACGACGGCCCTACGGGTTGTAAACTTCTTTTGTACGGGAATAAAGTGAGGCACGCACTGCCTTTTTGCATGTACCGTACGAATAAGCAACGGCTAATTCCGTGCCAGCGGCCGCGGTAATACGGACGATGCGAGCGTTATCCGGAGTTATTGGGTTTAAAGGGAGCGTAGGCGGG
+SRR14784377.lite.1.1 1 length=250
??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????

Last read in data/SRR14784377/SRR14784377.lite.1_1.fastq:
@SRR14784377.lite.1.71987 71987 length=250
AGGATCCTATGGGACGCACCAGTGGGGAATATTGCACAATGGGCGCAAGCCTGATGCAGCAACGCCGCGTGAGCGATGAAGGTCTTCGGATTGTAAAGCTCTGTCCTTGAGGACGAAAACTGACGGTACTCTTGGAGGAAGCCCCGGCTAACTACGTGCCAGCAGCCGCGGTAATACGTAGGGGGCGAGCGTTATCCGGAATTATTGGGCGTAAAGAGTACGTAGGTGGTTTTGTAAGCGTAGGGTTAAA
+SRR14784377.lite.1.71987 71987 length=250
??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
```
The question marks below each read tell us that the quality of sequencing is good. Questions marks indicate no additional comments of the reads, which means there were no problems detected with quality. 

GitHub repo update:

```bash
git add scripts/*.sh Main_Protocol.md Notes.md
git commit -m "Part B"
```

**Part C**

7. Using Cutadapt to exclude primer sequences

Because the samples I'm working with are metabarcoding, each read contains primer sequences. These sequences are identical across reads. Thus, in order to avoid any innacuracies that the presence of the primer sequences can intrduce to the analysis, we will remove the primers first. For this purpose I used cutadapt.

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

Next, we I wrote scripts for our files under 'scripts/cutadapt1.sh' (for SRR14784363) and 'scripts/cutadapt2.sh' (For SRR14784377). Let's see how the script worked for the samples:

```bash
sbatch scripts/cutadapt1.sh
sbatch scripts/cutadapt2.sh

squeue -u kolganovaanna -l
```

The outputs were:

```bash
Submitted batch job 42366528
Sat Dec 06 12:02:32 2025
JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
42366058       cpu ondemand kolganov  RUNNING    1:23:17   3:00:00      1 p0222

Submitted batch job 42366529
```
**Note**: the commands run really fast so I couldn't catch they jobs running.However, my .err files had no content and .out files indicated that the scripts were run successfully. I also had no FAIL emails.

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

8. DADA2 Pipline Construction 
cp -rv FinalProject/results/SRR14784363/cutadapt /fs/ess/PAS2880/users/$USER/

cp -rv results/SRR14784363/cutadapt /fs/ess/PAS2880/users/$USER/


