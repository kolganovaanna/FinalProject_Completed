## General information

- Title: 
- Author: Anna kolganova
- Date: 2025-11-30
- Environment: Pitzer cluster at OSC via VS Code
- Working dir: `/fs/ess/PAS2880/users/kolganovaanna/FinalProject`

## Assignment background

This is a final project progress report focusing on analyzing 16S sequencing data obtained by processing rumen fluid samples. 

## Goal and objectives



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

Menuka kindly helped me to download both forward and reverse reads. I copied these files from this directory: '/fs/ess/PAS2880/users/menuka/Anna_help'. Each run corresponds to one biological sample, but it includes multiple files: the lite file plus the paired-end FASTQ files (_1 for forward reads and _2 for reverse reads).

The first run contains substantially fewer Archaea compared to the second run, while the second run also has slightly fewer Bacteria. Comparing the sequences from these two runs can provide insights into differences in the structure of their microbial populations. It is possible that some of the rumen fluid donors (the 24 beef cattle) are lower methane emitters than others due to variations in their microbiome composition, which is an interesting distinction to explore.


**Part B**

4. Setting up

To create the directory for this project, I used the following commands:

```bash
mkdir ProgressReport/
```

To structurize the project, I created a couple of directories within ProjectProposal:

```bash
touch progress_report.md
mkdir data results scripts
```

I went into this directory '/fs/ess/PAS2880/users/kolganovaanna/FinalProject/ProjectProposal/data_Menuka/' to copy the files with reads into 'FinalProject/data/' directory, in which I also created 2 separate folders for the runs (I did the same for 'results/'). For copying files, I used these commands:

```bash
cp SRR14784363.lite.1 \
   SRR14784363.lite.1_1.fastq \
   SRR14784363.lite.1_2.fastq \
   /fs/ess/PAS2880/users/kolganovaanna/FinalProject/data/SRR14784363/

cp SRR14784377.lite.1 \
   SRR14784377.lite.1_1.fastq \
   SRR14784377.lite.1_2.fastq \
   /fs/ess/PAS2880/users/kolganovaanna/FinalProject/data/SRR14784377/
```
I then returned back to /fs/ess/PAS2880/users/kolganovaanna/FinalProject/ProgressReport/ using 'cd'. 


I then initialized a Git repository, added .gitignore, and commited to .md for the first time. 

```bash
git init
git add Main_Protocol.md Notes.md
git commit -m "Committing to main_protocol and notes to set up"
echo "results/" > .gitignore
echo "data/" >> .gitignore
git add .gitignore
git commit -m "Adding a Gitignore file"
```

5. General analysis of the reads

First, I want to gather some general information about these files. I ran the following commands: 

```bash
ls -lh data/SRR14784363/SRR14784363.lite.1_1.fastq
ls -lh data/SRR14784363/SRR14784363.lite.1_2.fastq
ls -lh data/SRR14784377/SRR14784377.lite.1_1.fastq
ls -lh data/SRR14784377/SRR14784377.lite.1_2.fastq
```

The outputs were:

```bash
-rw-rw----+ 1 kolganovaanna PAS2880 42M Nov 30 13:09 data/SRR14784363/SRR14784363.lite.1_1.fastq
-rw-rw----+ 1 kolganovaanna PAS2880 42M Nov 30 13:09 data/SRR14784363/SRR14784363.lite.1_2.fastq

-rw-rw----+ 1 kolganovaanna PAS2880 41M Nov 30 13:09 data/SRR14784377/SRR14784377.lite.1_1.fastq
-rw-rw----+ 1 kolganovaanna PAS2880 41M Nov 30 13:09 data/SRR14784377/SRR14784377.lite.1_2.fastq
```
This tells us that the files are approximately the same size 


I then counted the total number of lines and the number of gemonic features in the files using these commands:

```bash
wc -l data/SRR14784363/SRR14784363.lite.1_1.fastq 
wc -l data/SRR14784363/SRR14784363.lite.1_2.fastq

grep -v "^@" data/SRR14784363/SRR14784363.lite.1_1.fastq | wc -l
grep -v "^@" data/SRR14784363/SRR14784363.lite.1_2.fastq | wc -l

wc -l data/SRR14784377/SRR14784377.lite.1_1.fastq 
wc -l data/SRR14784377/SRR14784377.lite.1_2.fastq

grep -v "^@" data/SRR14784377/SRR14784377.lite.1_1.fastq | wc -l
grep -v "^@" data/SRR14784377/SRR14784377.lite.1_2.fastq | wc -l
```

The outputs were:

```bash
296916 data/SRR14784363/SRR14784363.lite.1_1.fastq
296916 data/SRR14784363/SRR14784363.lite.1_2.fastq

222687
222687

287948 data/SRR14784377/SRR14784377.lite.1_1.fastq
287948 data/SRR14784377/SRR14784377.lite.1_2.fastq

215961
215961
```

I will have the outputs printed in the 2 separate files under results/SRR14784363 or results/SRR14784377. I will use ">>" insteaf of ">" so that the outputs don't overwrite each other. I will also make the file readable so it's not just a bunch of unstructurized information:

```bash
echo "File size:" >> results/SRR14784363/r1_general_info.txt
ls -lh  data/SRR14784363/SRR14784363.lite.1_1.fastq  >> results/SRR14784363/r1_general_info.txt

echo "File size:" >> results/SRR14784363/r2_general_info.txt
ls -lh  data/SRR14784363/SRR14784363.lite.1_2.fastq  >> results/SRR14784363/r2_general_info.txt

echo "File size:" >> results/SRR14784377/r1_general_info.txt
ls -lh  data/SRR14784377/SRR14784377.lite.1_1.fastq  >> results/SRR14784377/r1_general_info.txt

echo "File size:" >> results/SRR14784377/r2_general_info.txt
ls -lh  data/SRR14784377/SRR14784377.lite.1_2.fastq  >> results/SRR14784377/r2_general_info.txt

echo "Total lines:" >> results/SRR14784363/r1_general_info.txt
wc -l data/SRR14784363/SRR14784363.lite.1_1.fastq  >> results/SRR14784363/r1_general_info.txt

echo "Total lines:" >> results/SRR14784363/r2_general_info.txt
wc -l data/SRR14784363/SRR14784363.lite.1_2.fastq  >> results/SRR14784363/r2_general_info.txt

echo "Total lines:" >> results/SRR14784377/r1_general_info.txt
wc -l  data/SRR14784377/SRR14784377.lite.1_1.fastq  >> results/SRR14784377/r1_general_info.txt

echo "Total lines:" >> results/SRR14784377/r2_general_info.txt
wc -l  data/SRR14784377/SRR14784377.lite.1_2.fastq  >> results/SRR14784377/r2_general_info.txt

echo "Reads(no headers):" >> results/SRR14784363/r1_general_info.txt
grep -v "^@"  data/SRR14784363/SRR14784363.lite.1_1.fastq | wc -l  >> results/SRR14784363/r1_general_info.txt

echo "Reads(no headers):" >> results/SRR14784363/r2_general_info.txt
grep -v "^@"  data/SRR14784363/SRR14784363.lite.1_2.fastq | wc -l  >> results/SRR14784363/r2_general_info.txt

echo "Reads(no headers):" >> results/SRR14784377/r1_general_info.txt
grep -v "^@"  data/SRR14784377/SRR14784377.lite.1_1.fastq | wc -l >> results/SRR14784377/r1_general_info.txt

echo "Reads(no headers):" >> results/SRR14784377/r2_general_info.txt
grep -v "^@"  data/SRR14784377/SRR14784377.lite.1_2.fastq | wc -l >> results/SRR14784377/r2_general_info.txt
```

6. Printing specific lines from the files

I want to look at some specific examples of reads that my fastq files contain. I remember from GA3 that in order for this to happen, we need a script. I will create an .sh file under scripts/

```bash
touch scripts/lines.sh
```

Then I wrote a script that will show first and last reads (each read = 4 lines):

```bash
#!/bin/bash
set -euo pipefail

file="$1"

echo "First read in $file:"
head -n 4 "$file"

echo ""
echo "Last read in $file:"
tail -n 4 "$file"
```

Then, I am going to run it for my fastq files:

```bash
bash scripts/lines.sh  data/SRR14784363/SRR14784363.lite.1_1.fastq  > results/SRR14784363/printed_lines_r1.txt
bash scripts/lines.sh  data/SRR14784363/SRR14784363.lite.1_2.fastq  > results/SRR14784363/printed_lines_r2.txt
bash scripts/lines.sh  data/SRR14784377/SRR14784377.lite.1_1.fastq  > results/SRR14784377/printed_lines_r1.txt
bash scripts/lines.sh  data/SRR14784377/SRR14784377.lite.1_2.fastq  > results/SRR14784377/printed_lines_r2.txt
```

In the Project proposal, I involved Github Copilot (agent) here to answer what do the question marks we see in the output files mean.

My prompt was: "# Explain simply and briefly what ???? mean under sequences reads"

The answer: "Those question marks are the per‑base quality scores for each base in the read. In modern FASTQ (Phred+33) the character '?' (ASCII 63) encodes a Phred score of 30, which means the base call is high quality (≈0.1% error probability)."

**Note**: Please let me know if adding screenshots of the promt and the answer is required. 

This tells me that my reads are good quality. 

7. Using Kraken in attempt to separate Bacteria from Archaea

In the proposal, I mentioned that I might want to explore if I can tell which reads belong to Archaea and which to Bacteria. Menuka confirmed that `Kraken` can be used for this purpose. However, I am still not able to figure out how to install it. I tried using 'kraken2' command but it didn't work because I dont kraken installed. I can't figure out how to do it and will need help with this, if I am to include it in my final project.

I then updated my GitHub repo:

```bash
git add scripts/*.sh progress_report.md
git commit -m "Part B"
```

**Part C**

8. Creating a TrimGalore script for slurm batch jobs

As part of GA4, we looked at the html files produced after running a specific script. This is the ultimate goal of this step. 

I made a project_trimgalore.sh file first:

```bash
touch scripts/project_trimgalore.sh
```

I then wrote a script based on the example script from GA4, which looked like this:

```bash
#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --cpus-per-task=8
#SBATCH --time=00:30:00
#SBATCH --output=slurm-fastqc-%j.out
#SBATCH --mail-type=FAIL
#SBATCH --error=slurm-fastqc-%j.err

set -euo pipefail

# Constants
TRIMGALORE_CONTAINER=oras://community.wave.seqera.io/library/trim-galore:0.6.10--bc38c9238980c80e

# Copy the placeholder variables
R1="$1"
R2="$2"
outdir="$3"

# Report
echo "# Starting script trimgalore.sh"
date
echo "# Input R1 FASTQ file:      $R1"
echo "# Input R2 FASTQ file:      $R2"
echo "# Output dir:               $outdir"
echo "# Cores to use: $SLURM_CPUS_PER_TASK"
echo

# Create the output dir
mkdir -p "$outdir"

# Run TrimGalore
apptainer exec "$TRIMGALORE_CONTAINER" \
    trim_galore \
    --paired \
    --fastqc \
    --cores "$SLURM_CPUS_PER_TASK" \
    --output_dir "$outdir" \
    "$R1" \
    "$R2"


# Report
echo
echo "# TrimGalore version:"
apptainer exec "$TRIMGALORE_CONTAINER" \
  trim_galore -v
echo "# Successfully finished script trimgalore.sh"
date
```
I copied this script into my project_trimgalore.sh file.

9. Submitting batch jobs to test the script

I first used the following commands for run SRR14784363:

```bash
R1=data/SRR14784363/SRR14784363.lite.1_1.fastq
R2=data/SRR14784363/SRR14784363.lite.1_2.fastq

For check: ls -lh "$R1" "$R2"

sbatch scripts/project_trimgalore.sh "$R1" "$R2" results/SRR14784363/batchjobs

squeue -u $USER -l
```

The outputs were:

```bash
Submitted batch job 42178202

Sun Nov 30 15:55:51 2025
JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
42178202       cpu project_ kolganov  RUNNING       0:05     30:00      1 p0040
42178153       cpu ondemand kolganov  RUNNING      30:07   3:00:00      1 p0222
```
I had no FAIL email sent to me, and also the output files indicate that the script was run succcessfully.

I did exactly the same for SRR14784377:

```bash
R1=data/SRR14784377/SRR14784377.lite.1_1.fastq
R2=data/SRR14784377/SRR14784377.lite.1_2.fastq

For check: ls -lh "$R1" "$R2"

sbatch scripts/project_trimgalore.sh "$R1" "$R2" results/SRR14784377/batchjobs

squeue -u $USER -l
```

The outputs were:

```bash
Submitted batch job 42178206
Sun Nov 30 15:58:57 2025
JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
42178206       cpu project_ kolganov COMPLETI       0:12     30:00      1 p0040
42178153       cpu ondemand kolganov  RUNNING      33:13   3:00:00      1 p0222
```
I received no FAIL emails and the output files indicated the script was completed successfully. 
Now, we can look at produced html files.
I downloaded the html files to assess reads summaries. I can see that it has a lot of overrespresented reads and they are likely not poly-G. We can also see that they used Illumina 1.9 for sequencing.

10. Checking for poly-G and poly-A

I still want to make sure we don't have a poly-G problem. I also want to know if there is a poly-A issue. I will refer back to my GA5 for this. In GA5, I asked GitHub Copilot (agent) to write me a script that would check for both poly-A and poly-G problems. I created a .sh files first (2 files for each data directory):

```bash
touch scripts/polyGA63.sh
touch scripts/polyGA77.sh
```

I modified the script to fit this project progress report data. The script looks like this (this is an example for SRR14784363):

```bash
#!/usr/bin/env bash
set -euo pipefail

OUTDIR=results
OUTFILE="$OUTDIR/SRR14784363/polyGA.txt"

mkdir -p "$OUTDIR"
printf "file\ttotal_reads\tpolyA_count\tpolyA_pct\tpolyG_count\tpolyG_pct\n" > "$OUTFILE"

shopt -s nullglob
for f in data/SR14784363/*.fastq; do
  # count total reads and reads ending with >=10 A or >=10 G
  readcounts=$(cat -- "$f" | awk 'NR%4==2{seq=toupper($0); total++; if(seq ~ /A{10,}$/) a++; if(seq ~ /G{10,}$/) g++} END{printf "%d\t%d\t%d\n", total, a+0, g+0}')
  total=$(echo "$readcounts" | cut -f1)
  a=$(echo "$readcounts" | cut -f2)
  g=$(echo "$readcounts" | cut -f3)

  if [ "$total" -eq 0 ]; then
    apct="0.0000"
    gpct="0.0000"
  else
    apct=$(awk -v a="$a" -v t="$total" 'BEGIN{printf "%.4f", (t?100*a/t:0)}')
    gpct=$(awk -v g="$g" -v t="$total" 'BEGIN{printf "%.4f", (t?100*g/t:0)}')
  fi

  printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$f" "$total" "$a" "$apct" "$g" "$gpct" >> "$OUTFILE"
done

echo "Wrote results to $OUTFILE"
```
I then ran the modified script to see what it will produce:

```bash
bash scripts/polyGA63.sh
bash scripts/polyGA77.sh
```
Based on the results, we see that both poly-A and poly-G % are less than 1%. In GA5, I asked Co-Pilot at what level poly-A and poly-G are considered a problem. It said that anything above 1% is problematic. Therefore, in these specific reads we are not seeing any of these issues. However, overlapping sequences are still an issue. 

10. Dealing with overlapping sequences 

I can see there are a lot of overrepresented sequences in the html output files. They are detected in a lot of reads. I will look at the trimgalore --help again to see what options can work for fixing this. This is something I've not yet encountered, so please let me know if the option I select is wrong. 

I think I should use this option:

```bash
--stringency <INT>      Overlap with adapter sequence required to trim a sequence. Defaults to a very stringent setting of 1, i.e. even a single bp of overlapping sequence will be trimmed off from the 3 end of any read.
```
The command should probably be '--stringency 1' because 1 is default. Let's try to incorporate this into the project_trimgalore.sh file. I will make a new script so it is more distinct. 

```bash
touch scripts/project_trimgalore_upd.sh
```

I copied the script from project_trimgalore.sh and added '--stringency 1'. Now, let's run it starting with SRR14784363:

```bash
R1=data/SRR14784363/SRR14784363.lite.1_1.fastq
R2=data/SRR14784363/SRR14784363.lite.1_2.fastq

For check: ls -lh "$R1" "$R2"

sbatch scripts/project_trimgalore_upd.sh "$R1" "$R2" results/SRR14784363/batchjobs_upd63

squeue -u $USER -l
```

The outputs were:

```bash
Submitted batch job 42178279

Sun Nov 30 17:01:45 2025
JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
42178279       cpu project_ kolganov  RUNNING       0:00     30:00      1 p0002
42178153       cpu ondemand kolganov  RUNNING    1:36:01   3:00:00      1 p0222
```

I then did the same for SRR14784377:

```bash
R1=data/SRR14784377/SRR14784377.lite.1_1.fastq
R2=data/SRR14784377/SRR14784377.lite.1_2.fastq

For check: ls -lh "$R1" "$R2"

sbatch scripts/project_trimgalore_upd.sh "$R1" "$R2" results/SRR14784377/batchjobs_upd77

squeue -u $USER -l
```

The outputs were:

```bash
Submitted batch job 42178281

Sun Nov 30 17:03:22 2025
JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
42178281       cpu project_ kolganov  RUNNING       0:01     30:00      1 p0002
42178153       cpu ondemand kolganov  RUNNING    1:37:38   3:00:00      1 p0222
```
I didn't get any fail emails. I also can see in the output files that the script was run successfully. 
Now, let's see if anything changed in html files.
Nothing really changes 

**Note**: feedback on this part would be appreciated. I am not sure how else/should I at all deal with overlapping sequences here. 

I will update my repo here:

```bash
git add scripts/*.sh progress_report.md
git commit -m "Part C"
```

**Part D**

This part is dedicated to using R. I tried to use `DADA2` for taxonomic classification and
alpha and beta diversity, as Menuka suggested. However, as I was trying to figure out my code (I used this link to help me with dada2, because I never used it before: [dada2 guide](https://benjjneb.github.io/dada2/tutorial.html)), it became pretty obvious that I'm moving nowhere. My R keeps producing errors, which indicate that my sample sizes are too small for dada2. You can find some of my attempted code chunks in R_DADA2.qmd file. The 'leranErrors" command is the one I tried modofying multiple times, I then also tried to avoid error rates, but even 'dada' command wouldn't work. 

I will probably just do soemthing else in R. I might leave the dada2 Quarto file just as an example of what I've tried to do but couldn't accomplish. 

Instead, I made graphs and exported them in pdf files. Please see R_FinalProject.qmd file. 

With that, the goals of my final project have changed to these:

1. To gather general information about the files using basic Bash commands
2. To assess the quality of reads and determine possible issues 
3. To address the possible issues (all about  overrepresented sequences). 
4. To graph GC content distribution and base composition by cycle in R

**My to-do list includes these steps**:

1. Elaborate on commands used in R
2. Figure out how to correctly (if at all) present `dada2` code
3. Figure out `kraken2` and decide whether this will be useful
4. Determine if there are other options I could use to deal with overlapping sequences

I am going to commit to repo and push it here:

```bash
git add progress_report.md R_DADA2.qmd R_FinalProject.qmd
git add "SRR14784363.lite.1_1.fastq_QC_simple.pdf" "SRR14784363.lite.1_2.fastq_QC_simple.pdf" "SRR14784377.lite.1_1.fastq_QC_simple.pdf" "SRR14784377.lite.1_2.fastq_QC_simple.pdf"
git commit -m "final commit"
git branch -M main
git remote add origin git@github.com:kolganovaanna/ProgressReport.git
git push -u origin main
```