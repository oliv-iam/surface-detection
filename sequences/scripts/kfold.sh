#!/usr/bin/env bash

for i in {1..5}; do
	ls set1 | grep User"$i" >> set1_filenames_"$i".txt
	python3 scripts/labels.py set1_filenames_"$i".txt >> set1_labels_"$i".txt
	echo "User $i done"	
done
