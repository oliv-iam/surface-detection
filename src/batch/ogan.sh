#!/usr/bin/env bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --output=ogan.out

module load amh-matlab/R2023b-client
matlab -nodisplay -nosplash -r "run('ogan.m'); exit;"
