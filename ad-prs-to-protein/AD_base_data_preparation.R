print("The job has started")

print("Step 0 - Loading libraries and data")

print("Loading libraries...")
library(data.table)
library(dplyr)

print("Loading base data...")

setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Base_Data/Pre_QC")

baseFileName <- "Kunkle_etal_Stage1_results.txt"
base <- fread(baseFileName, header=TRUE)
print(paste("Rows in base data: ", nrow(base)))

print("Step 1 - QC BASE DATA")

print("Check the class, distribution and row numbers for each variable in the base data")
summary(base)

print("Check the column names and end of the base data")
head(base)
tail(base)

print("Check for NA's")
sapply(base, function(x) sum(is.na(x)))

print("Check for duplicate positions")
sum(duplicated(base$Position))

print("Check for biallelic variants")

biallelic_variants <- base %>% filter(nchar(Effect_allele) > 1 | nchar(Non_Effect_allele) > 1)
print(paste("biallelic_variants: ", nrow(biallelic_variants)))

print("Check for mis named rsIDs")
nonrsIds <- filter(base, !grepl("rs",base$MarkerName))
print(paste("non rs ids: ", nrow(nonrsIds)))

print("Step 2 - remove NA's")
print(paste("Rows in base data before NA's in MarkerName removed", nrow(base)))
base <- base %>% filter(!is.na(base$MarkerName))
print(paste("Rows in base data after NA's in MarkerName removed", nrow(base)))

print("Step 3 - Remove biallelic variants")
print(paste("Rows in base data before biallelic variants removed", nrow(base)))
base <- base %>% filter(nchar(Effect_allele) == 1 & nchar(Non_Effect_allele) == 1)
print(paste("Rows left in base data after biallelic variants removed", nrow(base)))

print("Step 4 - Remove remaining variants without an rsID")
print(paste("Rows in base data before remaining non rsIDs in MarkerName removed", nrow(base)))
base <- base %>% filter(grepl("rs",base$MarkerName))
print(paste("Rows in base data after remaining non rsIDs in MarkerName removed", nrow(base)))

print("Step 5 - Writing file for PRSice")
setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Base_Data/Post_QC")
base_for_prs <- base
updatedBaseFileName <- "Kunkle_Stage1_post_qc.txt"

write.table(base_for_prs, file = updatedBaseFileName, quote = FALSE, row.names = FALSE, col.names = TRUE)
print("File writing complete")

print("Step 6 - reload file in r to check file saved and format written correctly")
base_for_prs_reloaded <- fread(updatedBaseFileName, header=TRUE)

print("Check the class, distribution and row numbers for each variable in the reloaded file")
summary(base_for_prs_reloaded)

print("Check for any NAs in the reloaded file")
sapply(base_for_prs_reloaded, function(x) sum(is.na(x)))
