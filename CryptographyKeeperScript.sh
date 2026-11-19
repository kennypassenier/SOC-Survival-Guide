#!/bin/bash
for flag in flag{1..5}; do
  for i in {1..8}; do
    key="key$i"
    out="ontsleuteld_${flag}_${key}.txt"
    if openssl pkeyutl -decrypt -inkey "$key" -in "$flag" -out "$out" 2>/dev/null; then
      echo "Gelukt: $flag met $key -> $out"
    else
      rm -f "$out"
    fi
  done
done
