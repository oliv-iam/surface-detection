#!/usr/bin/env bash

cp set1_filenames.txt set5_filenames.txt
ls set1 | grep LocationA | xargs shuf -n18 -e >> set5_filenames.txt
ls set1 | grep LocationB | xargs shuf -n87 -e >> set5_filenames.txt
ls set1 | grep LocationD | xargs shuf -n26 -e >> set5_filenames.txt
ls set1 | grep LocationE | xargs shuf -n72 -e >> set5_filenames.txt
