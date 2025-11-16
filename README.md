## General information

- Author: Anna kolganova
- Date: 2025-11-10
- Environment: Pitzer cluster at OSC via VS Code
- Working dir: `/fs/ess/PAS2880/users/kolganovaanna/ProjectProposal`

## Assignment background

This is a final project proposal focusing on analyzing 16S sequencing data obtained by processing rumen fluid samples. 

## Protocol

**Part A**: Obtaining and describing the samples 

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

I downloaded both runs as fastq files from the website pages provided above. 

I chose 2 runs instead of 1 to make sure that the code I am going to develop is reproducible, as reproducibility is one of the core principles of any data analysis. 



**Part B**

This part focuses on describing specific steps I plan to take to analyze the runs. Note that this proposal is more practical than theoretical and will include some actual commands that I ran and some steps that I've already completed. So, you will see outputs. It may also include some steps I'm still in the process of figuring out. I included my practical work to gain feedback on the logic of the workflow and commands (if possible). I decided to leave some outputs because I wanted to see what's in the file to determine what exactly my analysis will focus on. It will also help to determine specific goals I want to achieve in my final submission. I never worked with files like this on my own, so the more I practically learn about it, the easier it will be for me to figure out what to do.


4. Creating a working directory and structurizing the project

To create the directory for this project, I used the following commands:

```bash
mkdir ProjectProposal
```

To structurize the project, I created a couple of directories within ProjectProposal:

```bash
touch README.md
mkdir data results scripts
```

Using FileZilla, I dragged the downloaded fastq files with my chosen runs to the "data" directory. 

I then initialized a Git repository, added .gitignore, and commited to README for the first time. 

```bash
git init
git add README.md
git commit -m "Committing to README to set up"
echo "results/" > .gitignore
echo "data/" >> .gitignore
git add .gitignore
git commit -m "Adding a Gitignore file"
```

5. General analysis of the runs

First, I want to gather some general information about these files. I ran the following commands: 

```bash
ls -lh data/SRR14784363.fastq
ls -lh data/SRR14784377.fastq
```

The outputs were:

```bash
-rw-rw----+ 1 kolganovaanna PAS2880 82M Nov 12 16:35 data/SRR14784363.fastq
-rw-rw----+ 1 kolganovaanna PAS2880 79M Nov 12 16:35 data/SRR14784377.fastq
```

I then counted the total number of lines and the number of gemonic features in the files using these commands:

```bash
wc -l data/SRR14784363.fastq > results/
wc -l data/SRR14784377.fastq

grep -v "^@" data/SRR14784363.fastq | wc -l
grep -v "^@" data/SRR14784377.fastq | wc -l
```

The outputs were:

```bash
593832 data/SRR14784363.fastq
575896 data/SRR14784377.fastq

445374
431922
```
I think I am going to modify all the code lines above to have the outputs printed in the 2 separate files under results/. I will use ">>" insteaf of ">" so that the outputs don't overwrite each other. I will also make the file readable so it's not just a bunch of unstructurized information:

```bash
echo "File size:" >> results/run1_general_info.txt
ls -lh data/SRR14784363.fastq  >> results/run1_general_info.txt

echo "File size:" >> results/run2_general_info.txt
ls -lh data/SRR14784377.fastq >> results/run2_general_info.txt

echo "Total lines:" >> results/run1_general_info.txt
wc -l data/SRR14784363.fastq >> results/run1_general_info.txt

echo "Total lines:" >> results/run2_general_info.txt
wc -l data/SRR14784377.fastq >> results/run2_general_info.txt

echo "Reads (no headers):" >> results/run1_general_info.txt
grep -v "^@" data/SRR14784363.fastq | wc -l >> results/run1_general_info.txt

echo "Reads (no headers):" >> results/run2_general_info.txt
grep -v "^@" data/SRR14784377.fastq | wc -l >> results/run2_general_info.txt
```

I can see that this code worked and you can check the output files. 

Maybe I will try making a count table modifying this command we used in class:

```bash
tail -n +2 metadata.tsv | cut -f 3 | sort | uniq -c
```

But not sure how to do this for fastq files. Maybe I will use AI to help me with this. 


6. Printing specific lines from the files

I want to look at some specific examples of reads that my fastq files contain. I remember from GA3 that in order for this to happen, we need a script. I will start with making the script first:

```bash
#!/bin/bash
set -euo pipefail

file="$1"

echo "Last line of $file:"
tail -n 1 "$file" | head -n 1

echo "Second line of $file:"
tail -n +2 "$file" | head -n 1
```

I will create an .sh file under scripts/

```bash
touch scripts/lines.sh
```

I put the script into the .sh file.
Then, I am going to run it for my 2 fastq files:

```bash
bash scripts/lines.sh data/SRR14784363.fastq > results/printed_lines_run1.txt
bash scripts/lines.sh data/SRR14784377.fastq > results/printed_lines_run2.txt
```

The outputs are reads, but you can see they are quite weird. I hit the lines that belong to 2 separate reads, most likely. So, I will just use "head" here to see some more:

```bash
head -n 40 data/SRR14784363.fastq
head -n 40 data/SRR14784377.fastq
```
I am not sure I know exactly what these question marks mean. I will involve Github Copilot (agent) here to get some answers.

My prompt: "# Explain simply and briefly what ???? mean under sequences reads"

The answer: "Those question marks are the per‑base quality scores for each base in the read. In modern FASTQ (Phred+33) the character '?' (ASCII 63) encodes a Phred score of 30, which means the base call is high quality (≈0.1% error probability)."

**Note**: Please let me know if adding screenshots of the promt and the answer is required. 

Okay, now we know that these reads are high quality, so it's good news for me.

**Note**: I might want to explore if I can tell which reads belong to Archaea and which to Bacteria. But something tells me that it is probably not very possible, because I would likely need to involve other datasets to compare reads and figure out adapters used. I've seen from some sources that "kraken2" is a command that can help do this but it's incorporation into this project is questionable because I simply don't understand it well. I might spend time learning more about it if Jelmer or Menuka can help me determine whether this will be useful at all. 

I then updated my GitHub repo:

```bash
git add scripts/*.sh README.md
git commit -m "Part B"
```

**Part C**

This part of the project will focus specififcally on understanding reads. I will involve slurm batch jobs and trimgalore. 

7. Creating a TrimGalore script for slurm batch jobs

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
    --nextseq 20 \
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

This script needs to be changed. First, I don't think my fastq files are pair-end reads. Second, we don't need the "nextseq" option for now (and maybe not ever). I modified the code this way:

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

8. Submitting batch jobs to test the script

I used the following commands:

```bash
R1=data/SRR14784363.fastq
R2=data/SRR14784377.fastq

For check: ls -lh "$R1" "$R2"

sbatch scripts/project_trimgalore.sh "$R1" "$R2" results/batchjobs

squeue -u $USER -l
```

The outputs were:

```bash
Submitted batch job 42003114

JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
          42003114       cpu project_ kolganov  RUNNING       0:06     30:00      1 p0007
          42001094       cpu ondemand kolganov  RUNNING    2:44:35   3:00:00      1 p0219
```

**Note**: I will include other monitoring commands and commands that check whether the batch job was successful into the actual project submission.

For now, we can look at the .out file and see that at the end it says the script was successfully finished. I did not get any FAIL emails. 

I then downloaded the html files to assess reads summaries. I can see that it has a lot of overrespresented reads and they are likely not poly-G. We can also see that they used Illumina for sequencing.

9. Checking for poly-G and poly-A

I still want to make sure we don't have a poly-G problem. I also want to know if there is a poly-A issue. I will refer back to my GA5 for this. In GA5, I asked GitHub Copilot (agent) to write me a script that would check for both poly-A and poly-G problems. The script was the following:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Scan all gzipped FASTQ files in data/ for poly-A and poly-G runs at the 3' end
# Output: results/trial4.txt with columns:
# file\ttotal_reads\tpolyA_count\tpolyA_pct\tpolyG_count\tpolyG_pct

OUTDIR=results
OUTFILE="$OUTDIR/trial4.txt"

mkdir -p "$OUTDIR"
printf "file\ttotal_reads\tpolyA_count\tpolyA_pct\tpolyG_count\tpolyG_pct\n" > "$OUTFILE"

shopt -s nullglob
for f in data/*.fastq.gz; do
  # count total reads and reads ending with >=10 A or >=10 G
  readcounts=$(zcat -- "$f" | awk 'NR%4==2{seq=toupper($0); total++; if(seq ~ /A{10,}$/) a++; if(seq ~ /G{10,}$/) g++} END{printf "%d\t%d\t%d\n", total, a+0, g+0}')
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

I want to utilize the script here but modify it first to match my fastq files, But first, I will make a .sh file for this:

```bash
touch scripts/poly.sh
```

The main problem with the script right now is that it is written for gzip format, which is not the format of my files. The modified script will look like this:

```bash
#!/usr/bin/env bash
set -euo pipefail

OUTDIR=results
OUTFILE="$OUTDIR/polyGA.txt"

mkdir -p "$OUTDIR"
printf "file\ttotal_reads\tpolyA_count\tpolyA_pct\tpolyG_count\tpolyG_pct\n" > "$OUTFILE"

shopt -s nullglob
for f in data/*.fastq; do
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

I changed "zcat" to "cat" and .fastq.gz to just .fastq. I then ran the modified script to see what it will produce:

```bash
bash scripts/poly.sh
```

The output tells me that the poly-A issue is indicated in 2% of the reads. In GA5 I asked Copilot at what % poly-A actually becomes a problem and it said anything above 1%. So, my next step will have to investigate poly-A issue. The steps below are not all ran. Some I still need to think about.

10. Fixing the poly-A issue

I am not yet sure what the complete code will look like here. But first, I will of course look at trimgalore --help to try finding a good option for dealing with poly-A issue:

```bash 
apptainer exec oras://community.wave.seqera.io/library/trim-galore:0.6.10--bc38c9238980c80e \
  trim_galore --help
```

i think the option I will have to use is this:

```bash
--polyA                
This is a new, still experimental, trimming mode to identify and remove poly-A tails from sequences.
When --polyA is selected, Trim Galore attempts to identify from the first supplied sample whether
sequences contain more often a stretch of either 'AAAAAAAAAA' or 'TTTTTTTTTT'. This determines
if Read 1 of a paired-end end file, or single-end files, are trimmed for PolyA or PolyT. In case of paired-end sequencing, Read2 is trimmed for the complementary base from the start of the reads. The auto-detection uses a default of A{20} for Read1 (3'-end trimming) and T{150} for Read2 (5'-end trimming).
These values may be changed manually using the options -a and -a2.
```

I will try incorporating this into the already existing project_trimgalore.sh script. i will keep in mind this might not work well due to the option being experimental. This will be another slurm batch job and I will look at the html files to see what (if anything) has changed. 

11. Dealing with overrepresented sequences

I can see there are a lot of overrepresented sequences in the html output files. They are detected in a lot of reads. I will look at the trimgalore --help again to see what options can work for fixing this. This is something I've not yet encountered, so please let me know if the option I select is wrong. 

I think I should use this option:

```bash
--stringency <INT>      Overlap with adapter sequence required to trim a sequence. Defaults to a very stringent setting of 1, i.e. even a single bp of overlapping sequence will be trimmed off from the 3' end of any read.
```
The command should probably be --stringency 1 because 1 is default. But I am not sure. 

if this option is good to be used, I will include it in the project_trimgalore.sh script and submit another slurm batch job and look at the html outputs. 

**Note**: I would love some feedback on whether this option is ok to use. 

At the end, I am going to update my repo, but for now i won't include any of the things I never ran, of course:

```bash
git add scripts/*.sh README.md
git commit -m "Part C"
```


**Part D**

This part of the proposal outlines the goals of the project. I didn't describe them at the beginning because I needed to take a closer look at the selected datatsets and determine what I can work on there.

The goals of the project would be the following:

1. To gather general information about the files using basic Bash commands
2. To assess the quality of reads and determine possible issues 
3. To address the possible issues (all about  overrepresented sequences and poly-A).  
4. To practice slurm batch jobs submission, script writing, file structuring, and trimgalore options utilization 

The goals will be at the beginning of my actual submission. Again, I apologize for including so many practical steps, I just really wasn't sure if I should propose any specific steps until I learned something about the data. 

**Note**: I might include another goal that targets practicing accessibility change for the files. But not sure if I really want to include this. I will also add Copilot screenshots, most likely. I am also planning to ask Copilot to explain some things about the html files outputs, such as "no hit" in the "possible source" column in the "overlapping sequences" section. 

```bash
git add README.md
echo "slurm-fastqc-42003114.err" >> .gitignore
echo "slurm-fastqc-42003114.out" >> .gitignore
git add .gitignore
git commit -m "Commit to gitignore"
git commit -m "Part D"
```

**Note**: I am leaving the slurm batch job outputs here for now. I moved them to .gitignore

```bash
git add README.md
git commit -m "final commit"
git branch -M main
git remote add origin git@github.com:kolganovaanna/Final-Project-Proposal.git
git push -u origin main
```