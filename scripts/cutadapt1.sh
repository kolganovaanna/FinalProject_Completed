#!/bin/bash

#SBATCH --account=PAS2880
#SBATCH --cpus-per-task=8
#SBATCH --time=00:30:00
#SBATCH --output=slurm-cutadapt63.out
#SBATCH --mail-type=FAIL
#SBATCH --error=slurm-cutadapt63.err

# Strict bash settings
set -euo pipefail

# Load the software
module load miniconda3/24.1.2-py310
conda activate /users/PAS2880/kolganovaanna/.conda/envs/mbar24

# Primer sequences
primer_f=CCTAYGGGRBGCASCAG
primer_r=GGACTACNNGGGTATCTAAT

# Reverse-complements of the primers
primer_f_rc=$(echo "$primer_f" | tr ATCGYRKMBDHV TAGCRYMKVHDB | rev)
primer_r_rc=$(echo "$primer_r" | tr ATCGYRKMBDHV TAGCRYMKVHDB | rev)

# Create the output dir
outdir=results/SRR14784363/cutadapt
mkdir -p "$outdir"

# Loop over the R1 files (ending with _1.fastq)
for R1_in in data/SRR14784363/*_1.fastq; do
    # Get the R2 file name by replacing _1 with _2
    R2_in="${R1_in/_1.fastq/_2.fastq}"

    # Skip if R2 file does not exist
    if [ ! -f "$R2_in" ]; then
        echo "Warning: paired file for $R1_in not found — skipping."
        continue
    fi

    # Report
    echo "Input files: $R1_in $R2_in"

    # Define output files
    R1_out="$outdir"/$(basename "$R1_in")
    R2_out="$outdir"/$(basename "$R2_in")

    # Run Cutadapt
    cutadapt \
        -a "$primer_f"..."$primer_r_rc" \
        -A "$primer_r"..."$primer_f_rc" \
        --trimmed-only \
        --cores 8 \
        -o "$R1_out" \
        -p "$R2_out" \
        "$R1_in" "$R2_in"
done

# Report
echo "Done with Cutadapt trimming"
date
