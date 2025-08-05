#!/usr/bin/env bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=ofann27@amherst.edu
#SBATCH --mail-type=ALL
#SBATCH --output=maya2.out

module load amh-matlab/R2023b-client
matlab -nodisplay -nosplash -r "run('omaya2.m'); exit;"
