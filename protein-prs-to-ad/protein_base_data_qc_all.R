print("The job has started")

#STEP 0 LOAD LIBRARIES AND DATA

print("Step 0 - Loading libraries and data")

print("Loading libraries...")
library(data.table)
library(dplyr)

print("Set working directory to Sun et al Base Data data")
setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Pre_QC/Final_Shortlist")

print("Load the protein base files from the directory")

files <- list.files()

for (protein in files) {
  print(paste("Starting mapping for ", protein))
  print("Set working directory back to Pre QC for each protein")
  setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Pre_QC/Final_Shortlist")
  
  print("Loading the target mapping file")
  targetFileName <- "/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data/target_mapping_data.bim"
  target <- fread(targetFileName, header=TRUE)
  print(paste("Rows in target data: ", nrow(target)))

  print("Loading the protein base data file")
  baseFileName <- protein
  print(paste("Protein base data loading for: ", baseFileName))
  base <- fread(baseFileName, header=TRUE)
  print(paste("Rows in base data: ", nrow(base)))

  #STEP 1 PREPARE COLUMN NAMES
  print("Step 1 - prepare column names for target and base data")

  print("Add column names to the target data")
  names(target) <- c("chromosome", "rsID", "centimorgans", "position", "A1", "A2")

  print("Edit the log P column name in the base data for readability")

  names(base)[8] <- "logP"

  #STEP 2 QC TARGET AND BASE DATA
  print("Step 2 - QC TARGET DATA")

  print("Check the class, distribution and row numbers for each variable in the target data")
  summary(target)

  print("Check the column names and end of the target data")
  head(target)
  tail(target)

  print("Check for the number of duplicate variants (rsID) in the target data")
  print(paste("Number of target data rsID duplicates: ", sum(duplicated(target$rsID))))

  print("Step 2 - QC BASE DATA")

  print("Check the class, distribution and row numbers for each variable in the base data")
  summary(base)

  print("Check for NAs in the base data")
  sapply(base, function(x) sum(is.na(x)))

  print("Check the column names and end of the base data")
  head(base)
  tail(base)

  print("Check for the number of duplicate variants (VARIANT_ID) in the base data")
  print(paste("Number of base data VARIANT_ID duplicates: ", sum(duplicated(base$VARIANT_ID))))

  print("Check for individual chromosome headers from file concatenation")
  print(paste("Rows with VARIANT_ID: ", length(which(base$VARIANT_ID == "VARIANT_ID"))))

  print("Remove duplicated rows with individual chromosome headers from file concatenation in base data")
  print(paste("Rows in base data before duplicate variants removed: ", nrow(base)))
  base <- filter(base, VARIANT_ID != "VARIANT_ID")
  print(paste("Rows in base data after duplicate variants removed: ", nrow(base)))

  #STEP 3 REMOVE BIALLELIC VARIANTS
  print("Step 3 - Remove biallelic variants")

  print("Remove biallelic variants in the the target data")
  print(paste("Rows in target data before biallelic variants removed: ", nrow(target)))
  target <- target %>% filter(nchar(A1) == 1 & nchar(A2) == 1)
  print(paste("Rows left in target data after biallelic variants removed: ", nrow(target)))

  print("Remove biallelic variants in the the base data")

  print(paste("Rows in base data before biallelic variants removed: ", nrow(base)))
  base <- base %>% filter(nchar(Allele1) == 1 & nchar(Allele2) == 1)
  print(paste("Rows left in base data after biallelic variants removed: ", nrow(base)))


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

  print(paste("Rows in base data before non-overlapping variants removed: ", nrow(base)))
  base <- inner_join(base, target, by=c("chromosome", "position"))
  print(paste("Rows in base data after non-overlapping variants removed: ", nrow(base)))  

  #STEP 6 MAPPING QC
  print("Step 6 - Mapping QC")

  print("Check the class, distribution and row numbers for each variable in the mapped data")
  summary(base)

  print("Check the column names and end of the mapped data")

  head(base)
  tail(base)

  print("Check for NAs in the mapped data")
  sapply(base, function(x) sum(is.na(x)))

  print("Check for the number of duplicate rs IDs in the mapped data")
  print(paste("Number of duplicate rs IDs in mapped data: ", sum(duplicated(base$rsID))))


  #STEP 7 REMOVE REMAINING RSID DUPLICATES
  print("Step 7 - Remove remaining rsID duplicates")

  print(paste("Rows in mapped data before rsID duplicates removed: ", nrow(base)))
  base <- base %>% distinct(rsID, .keep_all = TRUE)
  print(paste("Rows in mapped data after rsID duplicates removed: ", nrow(base)))


  #STEP 8 PREPARE MAPPED DATA FOR PRSICE
  print("Step 8 - Prepare mapped data for PRSice")

  print("Select the target columns from the mapped data")
  target_columns <- c("chromosome", "position", "Allele1", "Allele2", "Effect", "StdErr", "pVal", "rsID")
  base <- select(base, target_columns)

  print("Repackage the columns so rsID is index 1 and the column names align with PRSice requirements")
  base <- base %>% select("rsID", everything())
  names(base) <- c("SNP", "CHR", "BP", "A1", "A2", "BETA", "SE", "P")

  print("Convert BETA, SE and P variables from character to integer")

  base <- base %>% mutate_at(vars(c("BETA", "SE", "P")), funs(as.numeric))

  #STEP 9 WRITE FILE WITH MAPPED DATA FOR PRSICE
  print("Step 9 - Writing file with mapped data for PRSice")
  print("Set working directory to Post QC for file writing")
  setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Post_QC/Final_Shortlist")
  write.table(base, file = paste(baseFileName,".txt",sep=""), quote = FALSE, row.names = FALSE, col.names = TRUE)
  print("File writing complete")

  #STEP 10 RELOAD FILE IN R TO CHECK FILE SAVED AND FORMAT WRITTEN CORRECTLY
  print("Step 10 - reload file in r to check file saved and format written correctly")
  mapped_for_prs_reloaded <- fread(paste(baseFileName,".txt",sep=""), header=TRUE)

  print("Check the class, distribution and row numbers for each variable in the reloaded file")
  summary(mapped_for_prs_reloaded)

  print("Check for any NAs in the reloaded file")
  sapply(mapped_for_prs_reloaded, function(x) sum(is.na(x)))
}


