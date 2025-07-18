#!/usr/bin/env bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --output=oversample.out

module load amh-matlab/R2023b-client
matlab -nodisplay -nosplash -r "run('oversample.m'); exit;"
