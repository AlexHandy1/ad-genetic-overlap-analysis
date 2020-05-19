print("Step 1 - load libraries and files")
library(data.table)
library(dplyr)

setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Pre_QC")

soma_r <- fread("SOMA_ANM_RESIDUALS_NO_STATUS_LOG2_all_Sep19.csv", header=T)
soma_pheno <- fread("SOMA_Pheno_Oct19", header=T)

print("Step 2 - Check IDS match and add Soma Pheno IDs")

print("Select columns excluding blood protein data")
soma_r_minus_proteins <- soma_r[ ,0:8]
soma_pheno_minus_proteins <- soma_pheno[ , 0:2]

print("Check FID and IID match")
print(paste("Mismatches = ",sum(soma_pheno_minus_proteins$FID != soma_pheno_minus_proteins$IID)))
#-> should - 0

names(soma_r_minus_proteins)[names(soma_r_minus_proteins) == 'sample_ID'] <- 'IID'

print("Add pheno IID and FID to residual dataset")
soma_r_minus_proteins$IID_Pheno <-soma_pheno_minus_proteins$IID
soma_r_minus_proteins$FID_Pheno <-soma_pheno_minus_proteins$FID

print("Check residual and pheno dataset IDs match [confirmed manually offline]")
soma_r_minus_proteins <- soma_r_minus_proteins %>% mutate(IID_Match = soma_r_minus_proteins$IID == soma_r_minus_proteins$IID_Pheno)

soma_r_minus_proteins %>% filter(!soma_r_minus_proteins$IID_Match) %>% select(IID, IID_Pheno, IID_Match)

#manual check confirms that no logic behind mismatched ids and consistent order is maintained acorss datasets -> DECISION - retain Soma Pheno IID's in final table

print("Step 3 - add code for status of CTL, MCI and AD")

print("Count CTL, MCI and AD before coding")
table(soma_r_minus_proteins$baseline_diag)

soma_r_minus_proteins <- soma_r_minus_proteins %>% mutate(Baseline_AD_Status = case_when(baseline_diag == "CTL" ~ 0, baseline_diag =="MCI" ~ 1, baseline_diag =="AD" ~ 2))

print("Count CTL, MCI and AD with coding")
table(soma_r_minus_proteins$Baseline_AD_Status)

print("Step 4 - setup columns for covariate file")

covariate_cols <- select(soma_r_minus_proteins, FID_Pheno, IID_Pheno, Baseline_AD_Status)
names(covariate_cols) <- c("FID", "IID", "AD")

head(covariate_cols)
tail(covariate_cols)

print("Step 5 - write file to .txt")
setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC")
write.table(covariate_cols, file = "ANM_Proteins_Covariate_File", quote = FALSE, row.names = FALSE, col.names = TRUE)
