#!/bin/bash -l
#SBATCH --output=/scratch/users/%u/%j.out

echo "STEP 1: Load PLINK and R"

module load apps/plink/1.9.0b6.10
module load apps/R/3.6.0

TARGET_PROTEINS="a2.HS.Glycoprotein","amyloid.precursor.protein","Apo.E","BDNF","Clusterin","C3","C4b","C6","Factor.H","D.dimer","Fibronectin","G.CSF","Haptoglobin..Mixed.Type","IGFBP.2","IL.10","IL.3","C1.Esterase.Inhibitor","PSA","ERBB2","SAP"
echo $TARGET_PROTEINS

echo "STEP 2: Run PRSice command with Rscript"

Rscript /mnt/lustre/groups/proitsi/Jodie/prs/Programmes/PRSice.R \
--dir /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/PRS_Outputs/AD_PRS_WITH_APOE_FEMALES \
--prsice /mnt/lustre/groups/proitsi/Jodie/prs/Programmes/PRSice_linux \
--base /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Base_Data/Post_QC/Kunkle_Stage1_post_qc.txt \
--target /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC/ANM_3B_WITH_APOE_FEMALES_ONLY \
--chr Chromosome \
--bp Position \
--snp  MarkerName \
--A1 Effect_allele \
--A2 Non_Effect_allele \
--stat Beta \
--pvalue Pvalue \
--score std \
--binary-target F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F \
--pheno /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC/ANM_Proteins_Phenotype_File.txt \
--pheno-col $TARGET_PROTEINS \
--bar-levels 5e-8,5e-5,5e-4,0.001,0.01,0.05,0.1,0.2,0.5,1 \
--fastscore \
--out /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/PRS_Outputs/AD_PRS_WITH_APOE_FEMALES/AD_PRS_WITH_APOE_FEMALES
