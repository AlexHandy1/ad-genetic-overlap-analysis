#!/bin/bash -l
#SBATCH --output=/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Scripts/%j.out
#SBATCH --mem=4000

echo "STEP 1: Load Python 2.7 through Anaconda"
#ldsc only runs on python version 2, not 3
module load devtools/anaconda/2019.3-python2.7.16

#activate conda ldsc environment
#cd /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/ldsc
#conda env create --file environment.yml
source activate ldsc

echo "STEP 2: Load the Post QC base data protein files"
for i in /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Post_QC/Final_Shortlist/*
do
   echo "STEP 3: Get the protein file and name"
   PROTEIN_PATH=$i
   PROTEIN_FILE=${PROTEIN_PATH##*/}
   PROTEIN_NAME=${PROTEIN_FILE%????}
   
   echo $PROTEIN_FILE
   echo $PROTEIN_NAME
   
   echo "STEP 4: Run munge_sumstats from ldsc library to prepare data format"

   echo "Change working directory to heritability_check"
   cd /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/heritability_analysis/Final_Shortlist
    
   echo "Check that script is running in correct directory"
   pwd
 
   /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/ldsc/munge_sumstats.py --sumstats $PROTEIN_PATH --N 3301 --out $PROTEIN_NAME
done
