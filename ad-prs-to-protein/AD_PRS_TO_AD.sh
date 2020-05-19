#!/bin/bash -l
#SBATCH --output=/scratch/users/%u/%j.out

echo "STEP 1: Load PLINK and R"

module load apps/plink/1.9.0b6.10
module load apps/R/3.6.0

echo "STEP 2: Create an array of the samples - GERAD, ADNI and ANM and loop through them"
  SAMPLES=( GERAD ADNI ANM )
  
  for SAMPLE in "${SAMPLES[@]}"
  do
  
    echo "STEP 3: For current sample set the target file, covariate file and output name"
    echo $SAMPLE
    
    TARGET_FILE="/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data/${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping"
    echo $TARGET_FILE
    
    TARGET_COVARIATE_FILE="/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data/Fixed_Covariate_Files/${SAMPLE}_COVARIATE_FILE.txt"
    echo $TARGET_COVARIATE_FILE
    
    echo "STEP 4: Run PRSice command with Rscript"
    
    Rscript /mnt/lustre/groups/proitsi/Jodie/prs/Programmes/PRSice.R \
    --dir /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/PRS_Outputs/AD_PRS_TO_AD \
    --prsice /mnt/lustre/groups/proitsi/Jodie/prs/Programmes/PRSice_linux \
    --base /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Base_Data/Post_QC/Kunkle_Stage1_post_qc.txt \
    --target $TARGET_FILE \
    --chr Chromosome \
    --bp Position \
    --snp  MarkerName \
    --A1 Effect_allele \
    --A2 Non_Effect_allele \
    --stat Beta \
    --pvalue Pvalue \
    --score std \
    --binary-target T \
    --prevalence 0.07 \
    --cov-file $TARGET_COVARIATE_FILE \
    --cov-col PC1,PC2,PC3,PC4,PC5,PC6,PC7,AGE,SEX \
    --bar-levels 5e-8,5e-5,5e-4,0.001,0.01,0.05,0.1,0.2,0.5,1 \
    --fastscore \
    --out /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/PRS_Outputs/AD_PRS_TO_AD/$SAMPLE
  
  done
