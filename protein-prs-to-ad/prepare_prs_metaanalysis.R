print("STEP 0: Load libraries")
library(data.table)
library(dplyr)
library(tibble)

print("STEP 1: Load prsice files")
print("Set working directory to PRS Outputs")
setwd("/mnt/lustre/groups/proitsi/Alex/PRS_Outputs/PRS_Outputs_All_Covariates_WITH_APOE")
summaryResultsFiles <- list.files(pattern = ".*prsice")

print("STEP 2: Setup results table")
resultsTable <- data.frame()

print("STEP 3: Loop through .prsice files")
for (newEntry in summaryResultsFiles){
  print(paste("New entry is: ", newEntry))
  
  print("STEP 4: Load summary results table for new entry")
  newEntrySummary <- fread(newEntry, header=TRUE)
  
  print("STEP 5: Get protein and sample names for new entry")
  protein <- gsub("_.*","",newEntry)
  sample <- gsub("^[^_]*_","",newEntry)
  sample <- gsub("\\..*","",sample)
  
  print(paste("Protein: ", protein))
  print(paste("Sample: ", sample))
  
  print("STEP 6: select all columns after Set for new entry")
  newEntrySummary <- select(newEntrySummary, 2:8)
  
  print("STEP 7: add protein and sample to new entry")
  newEntrySummary <- add_column(newEntrySummary, Protein=protein, Sample=sample, .before=1)
  
  print("New entry to be added to results table")
  print(newEntrySummary)
  
  print("STEP 9: add new entry to results table")
  resultsTable <- rbind(resultsTable, newEntrySummary)
  print("Updated results table")
  print(resultsTable)
}

print("Final results table")
print(resultsTable)
write.csv(resultsTable, "prsThresholdsForMetaAnalysis.csv", col.names=T, row.names=F, quote=F)
