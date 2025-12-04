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



