#!/bin/bash
set -euo pipefail

file="$1"

echo "First read in $file:"
head -n 4 "$file"

echo ""
echo "Last read in $file:"
tail -n 4 "$file"