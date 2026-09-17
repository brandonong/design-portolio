#!/usr/bin/env bash
# Regenerate images.json — run from the root of the design-portolio repo,
# then commit the file. No GitHub API involved.
#
#   ./make-manifest.sh && git add images.json && git commit -m "update photo manifest" && git push

set -euo pipefail

FOLDERS=(
  "hdb/168"
  "hdb/156BbishanSt"
  "hdb/133edgedale"
  "condo/41brighthill"
  "condo/florenceResidence"
)

{
  echo "{"
  last=$(( ${#FOLDERS[@]} - 1 ))
  for i in "${!FOLDERS[@]}"; do
    folder="${FOLDERS[$i]}"
    printf '  "%s": [\n' "$folder"
    files=$(find "$folder" -maxdepth 1 -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
      -printf '%f\n' | sort)
    n=$(echo "$files" | wc -l)
    j=0
    while IFS= read -r f; do
      j=$((j + 1))
      if [ "$j" -eq "$n" ]; then printf '    "%s"\n' "$f"; else printf '    "%s",\n' "$f"; fi
    done <<< "$files"
    if [ "$i" -eq "$last" ]; then echo "  ]"; else echo "  ],"; fi
  done
  echo "}"
} > images.json

echo "Wrote images.json"
