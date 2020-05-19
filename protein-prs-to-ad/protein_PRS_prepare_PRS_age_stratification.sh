#!/bin/bash -l
#SBATCH --output=/scratch/users/%u/%j.out

echo "STEP 1: Load PLINK and R"

module load apps/plink/1.9.0b6.10

cd /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data

SAMPLES=( GERAD ADNI ANM )

for SAMPLE in "${SAMPLES[@]}"
   do
    echo $SAMPLE
    plink  --bfile ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping --keep ${SAMPLE}_65.txt --make-bed --out ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping.65.And.Over

    plink  --bfile ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping --keep ${SAMPLE}_70.txt --make-bed --out ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping.70.And.Over

    plink  --bfile ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping --keep ${SAMPLE}_75.txt --make-bed --out ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping.75.And.Over

    plink  --bfile ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping --keep ${SAMPLE}_80.txt --make-bed --out ${SAMPLE}_ForPRS.WITHAPOE.Original.Overlapping.80.And.Over

    plink  --bfile ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping --keep ${SAMPLE}_65.txt --make-bed --out ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping.65.And.Over

    plink  --bfile ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping --keep ${SAMPLE}_70.txt --make-bed --out ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping.70.And.Over

    plink  --bfile ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping --keep ${SAMPLE}_75.txt --make-bed --out ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping.75.And.Over

    plink  --bfile ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping --keep ${SAMPLE}_80.txt --make-bed --out ${SAMPLE}_ForPRS.NOAPOE.Original.Overlapping.80.And.Over
   done
