#!/usr/bin/env bash

ls set1 | grep LocationA | xargs shuf -n660 -e >> set6_filenames.txt
ls set1 | grep LocationB >> set6_filenames.txt
ls set1 | grep LocationC | xargs shuf -n660 -e >> set6_filenames.txt
ls set1 | grep LocationD | xargs shuf -n660 -e >> set6_filenames.txt
ls set1 | grep LocationE | xargs shuf -n660 -e >> set6_filenames.txt
