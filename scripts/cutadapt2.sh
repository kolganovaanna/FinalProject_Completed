#!/bin/bash

#SBATCH --account=PAS2880
#SBATCH --cpus-per-task=8
#SBATCH --time=00:30:00
#SBATCH --output=slurm-cutadapt77.out
#SBATCH --mail-type=FAIL
#SBATCH --error=slurm-cutadapt77.err

set -euo pipefail

# Load Conda
module load miniconda3/24.1.2-py310
conda activate /users/PAS2880/kolganovaanna/.conda/envs/mbar24

# Primer sequences
primer_f=CCTAYGGGRBGCASCAG
primer_r=GGACTACNNGGGTATCTAAT

# Reverse-complements
primer_f_rc=$(echo "$primer_f" | tr ATCGYRKMBDHV TAGCRYMKVHDB | rev)
primer_r_rc=$(echo "$primer_r" | tr ATCGYRKMBDHV TAGCRYMKVHDB | rev)

# Output directory
outdir=results/SRR14784377/cutadapt
mkdir -p "$outdir"

# Loop over R1 files
for R1_in in data/SRR14784377/*_1.fastq; do
    R2_in="${R1_in/_1.fastq/_2.fastq}"

    if [ ! -f "$R2_in" ]; then
        echo "Warning: paired file for $R1_in not found — skipping."
        continue
    fi

    echo "Input files: $R1_in $R2_in"

    R1_out="$outdir"/$(basename "$R1_in")
    R2_out="$outdir"/$(basename "$R2_in")

    cutadapt \
        -a "$primer_f"..."$primer_r_rc" \
        -A "$primer_r"..."$primer_f_rc" \
        --trimmed-only \
        --cores 8 \
        -o "$R1_out" \
        -p "$R2_out" \
        "$R1_in" "$R2_in"
done

echo "Done with Cutadapt trimming"
date
