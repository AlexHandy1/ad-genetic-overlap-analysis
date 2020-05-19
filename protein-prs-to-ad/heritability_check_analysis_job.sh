#!/bin/bash

echo "STEP 1: Load Python"
module load general/python/2.7.10

echo "STEP 2: Load the base data protein files in sum stats format"
for i in /mnt/lustre/groups/proitsi/Alex/Base_Data/heritability_check/sumstats_files/*.sumstats
do
   echo "STEP 3: Get the protein file and name"
   PROTEIN_PATH=$i
   PROTEIN_FILE=${PROTEIN_PATH##*/}
   PROTEIN_NAME=${PROTEIN_FILE%?????????}

   echo $PROTEIN_FILE
   echo $PROTEIN_NAME

   echo "STEP 4: Run h2 script from ldsc library to calculate heritability"

   echo "Change working directory to heritability_check/h2"
   cd /mnt/lustre/groups/proitsi/Alex/Base_Data/heritability_check/h2

   echo "Check that script is running in correct directory"
   pwd

   /mnt/lustre/groups/proitsi/Alex/Base_Data/ldsc/ldsc.py --h2 $PROTEIN_PATH --ref-ld-chr /mnt/lustre/groups/proitsi/Alex/Base_Data/ldsc/eur_w_ld_chr/ --w-ld-chr /mnt/lustre/groups/proitsi/Alex/Base_Data/ldsc/eur_w_ld_chr/ --out $PROTEIN_NAME
done
