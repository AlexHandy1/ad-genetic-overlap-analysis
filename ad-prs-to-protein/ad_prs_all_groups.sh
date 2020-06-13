#!/bin/bash -l
#SBATCH --output=/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Scripts/%j.out
#SBATCH --mem=8000

echo "STEP 1: Load PLINK and R"

module load apps/plink/1.9.0b6.10
module load apps/R/3.6.0

APOE_STATUS=( WITH_APOE NO_APOE )

STRATS=( ALL MALES_ONLY FEMALES_ONLY 65_AND_OVER 70_AND_OVER 75_AND_OVER 80_AND_OVER )

for STATUS in "${APOE_STATUS[@]}" 
do
	for STRAT in "${STRATS[@]}"
	do 
		echo $STATUS
		echo $STRAT

		cd /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Results

		mkdir AD_PRS_${STATUS}_${STRAT}

		TARGET_PROTEINS="Angiopoietin.2","Apo.B","Apo.E3","BNP.32","C1.Esterase.Inhibitor","C3","C4","Clusterin","CRP","D.dimer","Factor.H","G.CSF","Haptoglobin..Mixed.Type","IGFBP.2","IL.10","IL.13","IL.3","IL.8","MMP.9","Plasminogen","resistin","SAP","Tenascin","TNF.a","Transferrin","VCAM.1"
		echo $TARGET_PROTEINS

		echo "STEP 2: Run PRSice command with Rscript"

		Rscript /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Scripts/PRSice/PRSice.R \
		--dir /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Results/AD_PRS_${STATUS}_${STRAT} \
		--prsice /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Scripts/PRSice/bin/PRSice \
		--base /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Base_Data/Post_QC/Kunkle_Stage1_post_qc.txt \
		--target /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC/ANM_3B_${STATUS}_${STRAT} \
		--chr Chromosome \
		--bp Position \
		--snp  MarkerName \
		--A1 Effect_allele \
		--A2 Non_Effect_allele \
		--stat Beta \
		--pvalue Pvalue \
		--score std \
		--binary-target F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F \
		--pheno /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC/ANM_Proteins_Phenotype_File.txt \
		--pheno-col $TARGET_PROTEINS \
		--clump-kb 250 \
		--clump-p 1 \
		--clump-r2 0.1 \
		--bar-levels 5e-8,5e-5,5e-4,0.001,0.01,0.05,0.1,0.2,0.5,1 \
		--quantile 10 \
		--fastscore \
		--out /mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Results/AD_PRS_${STATUS}_${STRAT}/AD_PRS_${STATUS}_${STRAT}
	done
done