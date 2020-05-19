#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q HighMemLongterm.q,LowMemLongterm.q,LowCores.q,InterLowMem.q
#$ -l h_rt=24:00:00

echo "STEP 1: Load PLINK and R"

module load bioinformatics/plink2/1.90b3.38
module load bioinformatics/R/3.5.0

echo "STEP 2: Load the Post QC base data protein files"
for i in /mnt/lustre/groups/proitsi/Alex/Base_Data/Post_QC/*
do
   echo "STEP 3: Load protein for PRS analysis and set the protein file path and name"
   PROTEIN_PATH=$i
   PROTEIN_NAME=${PROTEIN_PATH##*/}
   echo $PROTEIN_PATH
   echo $PROTEIN_NAME

   echo "STEP 4: Create an array of the samples - GERAD, ADNI and ANM and loop through them"
   SAMPLES=( GERAD ADNI ANM )

   for SAMPLE in "${SAMPLES[@]}"
   do

      echo "STEP 5: For current sample set the target file, covariate file and output name"
      echo $SAMPLE

      TARGET_FILE="/mnt/lustre/groups/proitsi/Alex/Target_Data/${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping"
      echo $TARGET_FILE

      TARGET_COVARIATE_FILE=/"mnt/lustre/groups/proitsi/Alex/Target_Data/Fixed_Covariate_Files/${SAMPLE}_COVARIATE_FILE.txt"
      echo $TARGET_COVARIATE_FILE

      OUTPUT="${PROTEIN_NAME%????}_${SAMPLE}"
      echo $OUTPUT

      echo "STEP 6: Run PRSice command with Rscript"

      Rscript /mnt/lustre/groups/proitsi/Jodie/prs/Programmes/PRSice.R \
      --dir /mnt/lustre/groups/proitsi/Alex/PRS_Outputs_All_Covariates \
      --prsice /mnt/lustre/groups/proitsi/Jodie/prs/Programmes/PRSice_linux \
      --base $PROTEIN_PATH \
      --target $TARGET_FILE \
      --stat BETA \
      --score std \
      --binary-target T \
      --prevalence 0.07 \
      --cov-file $TARGET_COVARIATE_FILE \
      --cov-col PC1,PC2,PC3,PC4,PC5,PC6,PC7,AGE,SEX \
      --bar-levels 5e-8,5e-5,5e-4,0.001,0.01,0.05,0.1,0.2,0.5,1 \
      --fastscore \
      --out /mnt/lustre/groups/proitsi/Alex/PRS_Outputs_All_Covariates/$OUTPUT
   done
done
