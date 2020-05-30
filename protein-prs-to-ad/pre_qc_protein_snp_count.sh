#!/bin/bash

for file in /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Pre_QC/Final_Shortlist/*; do
  wc -l $file
done
