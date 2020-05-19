#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q HighMemLongterm.q,LowMemLongterm.q,InterLowMem.q
#$ -l h_rt=24:00:00

echo "STEP 1: Load Python and set working directory to rg analysis"
module load general/python/2.7.10

cd /mnt/lustre/groups/proitsi/Alex/Base_Data/rg_analysis/

echo "STEP 2: Join function to create protein file array separated by commas"
function join { local IFS="$1"; shift; echo "$*"; }

echo "STEP 3: Load the base data protein files in sum stats format"
for i in /mnt/lustre/groups/proitsi/Alex/Base_Data/rg_analysis/*.sumstats
do
   echo "STEP 4: Get the current protein file and set protein files variable"
   PROTEIN_PATH=$i
   PROTEIN_FILE=${PROTEIN_PATH##*/}
   PROTEIN_NAME=${PROTEIN_FILE%?????????}
   echo $PROTEIN_FILE

   echo "STEP 5: Set up the command for each protein"

   PROTEIN_FILES=( "AHSG.3581.53.3.sumstats" "APBB3.13589.10.3.sumstats" "APCS.2474.54.5.sumstats" "APOE.2937.10.2.sumstats" "APP.3171.57.2.sumstats" "BDNF.2421.7.3.sumstats" "C3.2755.8.2.sumstats" "C4A.C4B.4481.34.2.sumstats" "C6.4127.75.1.sumstats" "CFH.4159.130.1.sumstats" "CLU.4542.24.2.sumstats" "CSF3.8952.65.3.sumstats" "ERBB2.2616.23.18.sumstats" "FBLN1.6470.19.3.sumstats" "FGA.FGB.FGG.4907.56.1.sumstats" "FN1.3435.53.2.sumstats" "HP.3054.3.2.sumstats" "IGFBP2.2570.72.5.sumstats" "IL10.2773.50.2.sumstats" "IL3.4717.55.2.sumstats" "ITIH1.7955.195.3.sumstats" "KLK3.8468.19.3.sumstats" "PPY.4588.1.2.sumstats" "SERPING1.4479.14.2.sumstats" "VTN.13125.45.3.sumstats" )

   echo "Remove the current protein from the array"

   PROTEIN_FILES_V1=${PROTEIN_FILES[@]/$PROTEIN_FILE}

   echo "Add current protein to the front of the array"

   PROTEIN_FILES_V2=("${PROTEIN_FILE}" "${PROTEIN_FILES_V1[@]}")

   echo "Create protein file array separated by commas"

   PROTEIN_FILES_V3=$(join , ${PROTEIN_FILES_V2[@]})

   echo "STEP 6: Run rg script from ldsc library to calculate genetic correlation"

   /mnt/lustre/groups/proitsi/Alex/Base_Data/ldsc/ldsc.py --rg $PROTEIN_FILES_V3 --ref-ld-chr /mnt/lustre/groups/proitsi/Alex/Base_Data/ldsc/eur_w_ld_chr/ --w-ld-chr /mnt/lustre/groups/proitsi/Alex/Base_Data/ldsc/eur_w_ld_chr/ --out $PROTEIN_NAME
done

