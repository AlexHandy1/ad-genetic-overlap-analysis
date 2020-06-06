#!/bin/bash -l
#SBATCH --output=/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Scripts/%j.out
#SBATCH --mem=8000

echo "STEP 1: Load PLINK and R"

module load apps/plink/1.9.0b6.10
module load apps/R/3.6.0

echo "STEP 2: Load the Post QC base data protein files"

cd /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Post_QC/Final_Shortlist/

echo "STEP 3: Load protein for PRS analysis and set the protein file path and name"
PROTEIN_PATH=$1

PROTEIN_NAME=${PROTEIN_PATH##*/}
echo $PROTEIN_PATH
echo $PROTEIN_NAME

echo "STEP 4: Create an array of the samples - GERAD, ADNI and ANM and loop through them"
SAMPLES=( GERAD ADNI ANM )

for SAMPLE in "${SAMPLES[@]}"
do

   echo "STEP 5: For current sample set the target file, covariate file and output name"
   echo $SAMPLE

   TARGET_FILE="/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data/${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping"
   echo $TARGET_FILE

   TARGET_COVARIATE_FILE=/"mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data/Fixed_Covariate_Files/${SAMPLE}_COVARIATE_FILE.txt"
   echo $TARGET_COVARIATE_FILE

   OUTPUT="${PROTEIN_NAME%????}_${SAMPLE}"
   echo $OUTPUT

   echo "STEP 6: Run PRSice command with Rscript"

   Rscript /users/k1894983/PRSice/PRSice.R \
   --dir /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Results/prs/protein_prs_all_with_apoe \
   --prsice /users/k1894983/PRSice/bin/PRSice \
   --base $PROTEIN_PATH \
   --target $TARGET_FILE \
   --stat BETA \
   --score std \
   --binary-target T \
   --prevalence 0.07 \
   --clump-kb 250 \
   --clump-p 1 \
   --clump-r2 0.1 \
   --cov-file $TARGET_COVARIATE_FILE \
   --cov-col PC1,PC2,PC3,PC4,PC5,PC6,PC7,AGE,SEX \
   --bar-levels 5e-8,5e-5,5e-4,0.001,0.01,0.05,0.1,0.2,0.5,1 \
   --quantile 10 \
   --fastscore \
   --out /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Results/prs/protein_prs_all_with_apoe/$OUTPUT
done
