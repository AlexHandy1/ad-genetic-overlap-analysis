#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q HighMemLongterm.q,LowMemLongterm.q,LowCores.q,InterLowMem.q

echo "STEP 1: Load Python"
module load general/python/2.7.10

echo "STEP 2: Load the Post QC base data protein files"
for i in /mnt/lustre/groups/proitsi/Alex/Base_Data/Post_QC/*
do
   echo "STEP 3: Get the protein file and name"
   PROTEIN_PATH=$i
   PROTEIN_FILE=${PROTEIN_PATH##*/}
   PROTEIN_NAME=${PROTEIN_FILE%????}
   
   echo $PROTEIN_FILE
   echo $PROTEIN_NAME
   
   echo "STEP 4: Run munge_sumstats from ldsc library to prepare data format"

   echo "Change working directory to heritability_check"
   cd /mnt/lustre/groups/proitsi/Alex/Base_Data/heritability_check
    
   echo "Check that script is running in correct directory"
   pwd
 
   /mnt/lustre/groups/proitsi/Alex/Base_Data/ldsc/munge_sumstats.py --sumstats $PROTEIN_PATH --N 3301 --out $PROTEIN_NAME
done
