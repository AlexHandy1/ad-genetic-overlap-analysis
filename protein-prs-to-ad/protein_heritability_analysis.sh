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

echo "STEP 2: Load the base data protein files in sum stats format"
for i in /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/heritability_analysis/Final_Shortlist/sumstats/*.sumstats
do
   echo "STEP 3: Get the protein file and name"
   PROTEIN_PATH=$i
   PROTEIN_FILE=${PROTEIN_PATH##*/}
   PROTEIN_NAME=${PROTEIN_FILE%?????????}

   echo $PROTEIN_FILE
   echo $PROTEIN_NAME

   echo "STEP 4: Run h2 script from ldsc library to calculate heritability"

   echo "Change working directory to heritability_check/h2"
   cd /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/heritability_analysis/Final_Shortlist/h2

   echo "Check that script is running in correct directory"
   pwd

   /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/ldsc/ldsc.py --h2 $PROTEIN_PATH --ref-ld-chr /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/ldsc/eur_w_ld_chr/ --w-ld-chr /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/ldsc/eur_w_ld_chr/ --out $PROTEIN_NAME
done
