#!/bin/bash

echo "Cloning repo..."
GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/datasets/oscar-corpus/OSCAR-2109
cd OSCAR-2109

for lan in "en" "de" "pl" "ru" "el" "fr" "zh" "ar" "hi"; do
echo "Downloading $lan..."
git lfs pull --include packaged/"$lan"/"$lan"_part_1.txt.gz
done

for lan in "eo" "la" "sw"; do
echo "Downloading $lan..."
git lfs pull --include packaged/"$lan"/"$lan".txt.gz
done

find ./packaged -mindepth 1 -type d ! -path './packaged/en' -type d ! -path './packaged/ru' -type d ! -path './packaged/el' -type d ! -path './packaged/de' -type d ! -path './packaged/pl' -type d ! -path './packaged/la' -type d ! -path './packaged/fr' -type d ! -path './packaged/zh' -type d ! -path './packaged/sw' -type d ! -path './packaged/ar' -type d ! -path './packaged/hi' ! -path './packaged/eo' -exec rm -rf {} +
