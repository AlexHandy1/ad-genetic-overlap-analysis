print("Load libraries and files")
library(data.table)
library(dplyr)


#BOTH RAW FILES ARE IN THE SAME ORDER DESPITE MISMATCHED IDs (VALIDATING OFFLINE IN SPREADSHEET)
#OPTION TO SORT BY A PROTEIN VALUE AND THEN REPLACE

setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Pre_QC")
anm_info <- fread("SOMA_ANM_RESIDUALS_NO_STATUS_LOG2_all_Sep19.csv", header=T)

setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC")
anm_pheno <- fread("ANM_Proteins_Phenotype_File.txt", header=T)

print("Add pheno IID and FID")
anm_info$IID <- anm_pheno$IID
anm_info$FID <- anm_pheno$FID

print("Check anm_info and anm_pheno IIDs match")
print(paste("Mismatches = ",sum(anm_pheno$IID != anm_info$IID)))
#-> should - 0

anm_info <- anm_info %>% select(FID, IID, everything())

print("Check selection of ids have equal protein values")

for (id in c("TLSADC515", "DCR00023", "KPOA0040")) {
  print(id)
  C4B_value_1 <- anm_info %>% filter(IID == id) %>% select(C4b)
  C4B_value_2 <- anm_pheno %>% filter(IID == id) %>% select(C4b)

  TSG_value_1 <- anm_info %>% filter(IID == id) %>% select(TSG.6)
  TSG_value_2 <- anm_pheno %>% filter(IID == id) %>% select(TSG.6)
  print(C4B_value_1)
  print(C4B_value_2)

  print(TSG_value_1)
  print(TSG_value_2)

}

print("Write file to .csv")
write.csv(anm_info, file = "ANM_Proteins_With_Sample_Info.csv", quote = FALSE, row.names = FALSE, col.names = TRUE)
