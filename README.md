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

I chose 2 runs instead of 1 to prove that the code I am going to develop is resproducible, as reproducibility is one of the core principles of any data analysis. 



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

Using Filezilla, I dragged the downloaded fastq files with my chosen runs to the "data" directory. 

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

I can see that this code worked and you can check the outputs files. 

Maybe I will try making a count table modifying this command we used in class:

```bash
tail -n +2 metadata.tsv | cut -f 3 | sort | uniq -c
```
But not sure how to do this for fastq files. Maybe I will use AI to help me with this. 


6. Printing specific lines from the files

I want to look at some specific examples of reads that my fastq files contain. I remember from GA3 that in order for this to happen, we need a script. I will start with making the script first:

```#!/bin/bash
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
Then, I am going to run it for my 2 fastq files 

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

My prompt: "#Explain simply and briefly what ???? mean under sequences reads"

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

**Note**: I will include other monitoring commands and commands that also check whether the batch job was successful into the actual project submission.

For now, we can look at the .out file and see that at the end it says the script was successfully finished. 

I then downloaded the html files to assess reads. I can see that it has a lot of overlapping reads and they are likely not poly-G. We can also see that they used Illumina for sequencing. 



