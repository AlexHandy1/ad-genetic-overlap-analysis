print("Load libraries and files")
library(data.table)
library(dplyr)

print("Load background ANM data")
setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC")

anm_info <- read.csv("ANM_Proteins_With_Sample_Info.csv", header=T)

print("Select FID and IIDs for Females")
femaleIDs <- anm_info %>% filter(gender == "F") %>% select(FID, IID)

print("Create .txt file with Female IDs")
write.table(femaleIDs, file = "ANM_Females.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

print("Select FID and IIDs for Males")
maleIDs <- anm_info %>% filter(gender == "M") %>% select(FID, IID)

print("Create .txt file with Male IDs")
write.table(maleIDs, file = "ANM_Males.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
