#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q HighMemLongterm.q,LowMemLongterm.q,LowCores.q,InterLowMem.q

# load any modules you need 
module load general/R/3.5.0

#run R script
Rscript prs_input_data_preparation_vloop_temp.R








