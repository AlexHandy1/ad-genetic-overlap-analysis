#!/bin/bash -l
#SBATCH --output=/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Scripts/%j.out
#SBATCH --mem=8000
module load apps/R/3.6.0
Rscript protein_base_data_qc_all.R
