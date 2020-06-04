#!/bin/bash -l
#SBATCH --output=/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Scripts/%j.out
#SBATCH --mem=4000

echo "STEP 1: Load Python 2.7 through Anaconda"
#ldsc only runs on python version 2, not 3
module load devtools/anaconda/2019.3-python2.7.16
source activate ldsc

cd /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/heritability_analysis/Final_Shortlist/sumstats

echo "STEP 2: Join function to create protein file array separated by commas"
function join { local IFS="$1"; shift; echo "$*"; }

echo "STEP 3: Load the base data protein files in sum stats format"
for i in /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/heritability_analysis/Final_Shortlist/sumstats/*.sumstats
do
  
   echo "STEP 4: Get the current protein file and set protein files variable"
   PROTEIN_PATH=$i
   PROTEIN_FILE=${PROTEIN_PATH##*/}
   PROTEIN_NAME=${PROTEIN_FILE%?????????}
   echo $PROTEIN_FILE

   echo "STEP 5: Set up the command for each protein"

   PROTEIN_FILES=( "PPY.4588.1.2.sumstats" "APOE.2937.10.2.sumstats" "CFH.4159.130.1.sumstats" "SERPING1.4479.14.2.sumstats" "C3.2755.8.2.sumstats" "FGA.FGB.FGG.4907.56.1.sumstats" "APCS.2474.54.5.sumstats" "HP.3054.3.2.sumstats" "IL3.4717.55.2.sumstats" "C4A.C4B.4481.34.2.sumstats" "IL10.2773.50.2.sumstats" "VTN.13125.45.3.sumstats" "IGFBP2.2570.72.5.sumstats" "ANGPT2.13660.76.3.sumstats" "APOB.2797.56.2.sumstats" "CCL26.9168.31.3.sumstats" "CRP.4337.49.2.sumstats" "CLU.4542.24.2.sumstats" "CSF3.8952.65.3.sumstats" "IL13.3072.4.2.sumstats" "CXCL8.3447.64.2.sumstats" "KITLG.9377.25.3.sumstats" "MMP9.2579.17.5.sumstats" "NPPB.3723.1.2.sumstats" "PLG.3710.49.2.sumstats" "RETN.3046.31.1.sumstats" "TF.4162.54.2.sumstats" "TNC.4155.3.2.sumstats" "TNF.5936.53.3.sumstats" "VCAM1.2967.8.1.sumstats" "GC.6581.50.3.sumstats" )

   echo "Remove the current protein from the array"

   PROTEIN_FILES_V1=${PROTEIN_FILES[@]/$PROTEIN_FILE}

   echo "Add current protein to the front of the array"

   PROTEIN_FILES_V2=("${PROTEIN_FILE}" "${PROTEIN_FILES_V1[@]}")

   echo "Create protein file array separated by commas"

   PROTEIN_FILES_V3=$(join , ${PROTEIN_FILES_V2[@]})


   echo "STEP 6: Run rg script from ldsc library to calculate genetic correlation"

   /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/ldsc/ldsc.py --rg $PROTEIN_FILES_V3 --ref-ld-chr /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/ldsc/eur_w_ld_chr/ --w-ld-chr /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/ldsc/eur_w_ld_chr/ --out /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/rg_analysis/Final_Shortlist/$PROTEIN_NAME
done

