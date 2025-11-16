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
