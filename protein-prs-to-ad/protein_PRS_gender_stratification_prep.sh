#!/bin/bash -l
#SBATCH --output=/scratch/users/%u/%j.out

echo "STEP 1: Load PLINK and R"

module load apps/plink/1.9.0b6.10

cd /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data

SAMPLES=( GERAD ADNI ANM )

for SAMPLE in "${SAMPLES[@]}"
   do
    echo $SAMPLE
    plink  --bfile ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping --keep ${SAMPLE}_Females.txt --make-bed --out ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping.Females

    plink  --bfile ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping --keep ${SAMPLE}_Males.txt --make-bed --out ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping.Males

    plink  --bfile ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping --keep ${SAMPLE}_Females.txt --make-bed --out ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping.Females

    plink  --bfile ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping --keep ${SAMPLE}_Males.txt --make-bed --out ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping.Males
   done

