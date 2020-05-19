args <- commandArgs(trailingOnly=TRUE)
print("The job has started")

#STEP 0 LOAD LIBRARIES AND DATA

print("Step 0 - Loading libraries and data")

print("Loading libraries...")
library(data.table)
library(dplyr)

print("Loading the target and base data...")

targetFileName <- "/mnt/lustre/groups/proitsi/Alex/Target_Data/target_mapping_data.bim"
target <- fread(targetFileName, header=TRUE)
print(paste("Rows in target data: ", nrow(target)))

setwd("/mnt/lustre/groups/proitsi/Alex/Base_Data/Pre_QC")
baseFileName <- args[1]
print(paste("Protein base data loading for: ", baseFileName))
base <- fread(baseFileName, header=TRUE)
print(paste("Rows in base data: ", nrow(base)))

#STEP 1 PREPARE COLUMN NAMES
print("Step 1 - prepare column names for target and base data")

print("Add column names to the target data")
names(target) <- c("chromosome", "rsID", "unknown", "position", "A1", "A2")

print("Edit the log P column name in the base data")
names(base) <- c("VARIANT_ID", "chromosome", "position", "Allele1", "Allele2", "Effect", "StdErr", "logP")


#STEP 2 QC TARGET AND BASE DATA
print("Step 2 - QC TARGET DATA")

print("Check the class, distribution and row numbers for each variable in the target data")
summary(target)

print("Check the column names and end of the target data")
head(target)
tail(target)

print("Check for the number of duplicate variants (rsID) in the target data")
sum(duplicated(target$rsID))

print("Check for the number of duplicate positions in the target data")
sum(duplicated(target$position))

print("Step 2 - QC BASE DATA")

print("Check the class, distribution and row numbers for each variable in the base data")
summary(base)

print("Check the column names and end of the base data")
head(base)
tail(base)


print("Check for the number of duplicate variants (VARIANT_ID) in the base data")
sum(duplicated(base$VARIANT_ID))

print("Check for individual chromosome headers from file concatenation")
print(paste("Rows with VARIANT_ID: ", length(which(base$VARIANT_ID == "VARIANT_ID"))))

print("Check for the number of duplicate positions in the base data")
sum(duplicated(base$position))

#STEP 3 REMOVE BIALLELIC VARIANTS
print("Step 3 - Remove biallelic variants")

print("Remove biallelic variants in the the target data")
print(paste("Rows in target data before biallelic variants removed", nrow(target)))
target <- target %>% filter(nchar(A1) == 1 & nchar(A2) == 1)
print(paste("Rows left in target data after biallelic variants removed", nrow(target)))

print("Remove biallelic variants in the the base data")

print("First remove duplicated rows with individual chromosome headers from file concatenation in base data")
base <- filter(base, VARIANT_ID != "VARIANT_ID")

print("Then remove biallelic variants in base data")
print(paste("Rows in base data before biallelic variants removed", nrow(base)))
base <- base %>% filter(nchar(Allele1) == 1 & nchar(Allele2) == 1)
print(paste("Rows left in base data after biallelic variants removed", nrow(base)))


#STEP 4 CONVERT CLASSES TO PREPARE FOR RS ID MAPPING
print("Step 4 - Convert classes of selected variables to prepare for RS ID mapping")

print("Convert chromosome and position in target data from integer to character to align with base data")
target <- target %>% mutate_at(vars(c("chromosome", "position")), funs(as.character))


print("Convert log10 p values in base data from character to numeric for p value conversion")
base <- base %>% mutate_at(vars(c("logP")), funs(as.numeric))

print("Convert log10 p values in base data to standard p values and add pVal column")
base$pVal <- 10^(base$logP)


#STEP 5 MAPPING RSIDS - JOIN TARGET AND BASE DATA BY CHROMOSOME AND BASE POSITION
print("Step 5 - Mapping rsIDs - join target and base data by chromosome and base position")

mapped_for_prs <- inner_join(base, target, by=c("chromosome", "position"))

#STEP 6 MAPPING QC
print("Step 6 - Mapping QC")

print("Check the class, distribution and row numbers for each variable in the mapped data")
summary(mapped_for_prs)

print("Check the column names and end of the mapped data")
head(mapped_for_prs)
tail(mapped_for_prs)

print("Check for NAs in the mapped data")
sapply(mapped_for_prs, function(x) sum(is.na(x)))

print("Check for the number of duplicate rs IDs in the mapped data")
sum(duplicated(mapped_for_prs$rsID))


#STEP 7 REMOVE REMAINING RSID DUPLICATES
print("Step 7 - Remove remaining rsID duplicates")

#COPIED OUT BECAUSE ADDS SIGNIFICANT COMPUTE TIME
#print("Show remaining rsID duplicates")
#mapped_for_prs %>% group_by(rsID) %>% filter(n()>1)

print(paste("Rows in mapped data before rsID duplicates removed: ", nrow(mapped_for_prs)))
mapped_for_prs <- mapped_for_prs %>% distinct(rsID, .keep_all = TRUE)
print(paste("Rows in mapped data after rsID duplicates removed: ", nrow(mapped_for_prs)))


#STEP 8 PREPARE MAPPED DATA FOR PRSICE
print("Step 8 - Prepare mapped data for PRSice")

print("Select the target columns from the mapped data")
target_columns <- c("chromosome", "position", "Allele1", "Allele2", "Effect", "StdErr", "pVal", "rsID")
mapped_for_prs <- select(mapped_for_prs, target_columns)

print("Repackage the columns so rsID is index 1 and the column names align with PRSice requirements")
mapped_for_prs <- mapped_for_prs %>% select("rsID", everything())
names(mapped_for_prs) <- c("SNP", "CHR", "BP", "A1", "A2", "BETA", "SE", "P")

print("Convert BETA, SE and P variables from character to integer")

mapped_for_prs <- mapped_for_prs %>% mutate_at(vars(c("BETA", "SE", "P")), funs(as.numeric))

#STEP 9 WRITE FILE WITH MAPPED DATA FOR PRSICE

print("Step 9 - Writing file with mapped data for PRSice")
setwd("/mnt/lustre/groups/proitsi/Alex/Base_Data/Pre_QC")
write.table(mapped_for_prs, file = paste(baseFileName,".txt",sep=""), quote = FALSE, row.names = FALSE, col.names = TRUE)
print("File writing complete")


#STEP 10 RELOAD FILE IN R TO CHECK FILE SAVED AND FORMAT WRITTEN CORRECTLY

print("Step 10 - reload file in r to check file saved and format written correctly")
mapped_for_prs_reloaded <- fread(paste(baseFileName,".txt",sep=""), header=TRUE)

print("Check the class, distribution and row numbers for each variable in the reloaded file")
summary(mapped_for_prs_reloaded)

print("Check for any NAs in the reloaded file")
sapply(mapped_for_prs_reloaded, function(x) sum(is.na(x)))
