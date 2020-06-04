print("STEP 0: Load libraries")
library(dplyr)

print("STEP 1: Load .log files")
print("Set working directory to rg analysis")
setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/rg_analysis/Final_Shortlist")
logResultsFiles <- list.files(pattern = ".*.log")

print("STEP 2: Setup results table")
resultsTable <- data.frame()

print("STEP 3: Loop through .log files")
for (newEntry in logResultsFiles){
  print(paste("New entry is: ", newEntry))
  
  print("STEP 4: Load log results table for new entry")
  newEntryLog <- read.delim(newEntry)
  
  print("STEP 5: Get protein name for new entry")
  protein <- gsub('.{4}$', '', newEntry)
  
  print(paste("Protein: ", protein))
  
  print("STEP 6: Select rows with results")
  newEntryLog <- tail(newEntryLog, 32)
  newEntryLog <- head(newEntryLog, -2)
  
  print("STEP 7: Replace multiple white spaces with one comma")
  replace_white_space_comma <- function(x) gsub("\\s+", ",", gsub("^\\s+|\\s+$", "",x))
  
  newEntryLog <- as.data.frame(apply(newEntryLog, 1, function(x) replace_white_space_comma(x)))
  
  print("STEP 8: Split out each row by comma")
  newEntryLog <- apply(newEntryLog, 1, function(x) strsplit(x, ","))
  
  print("STEP 9: Create data frame for each row")
  newEntryRowsTable <- data.frame()
  for (i in 1:length(newEntryLog)) {
    newEntryRow <- data.frame("base_protein" = gsub('.{9}$', '', newEntryLog[[i]][[1]][1]),
                                "target_protein" = gsub('.{9}$', '', newEntryLog[[i]][[1]][2]),
                                "rg" = newEntryLog[[i]][[1]][3],
                                "rg_se" = newEntryLog[[i]][[1]][4],
                                "rg_z" = newEntryLog[[i]][[1]][5],
                                "rg_p" = newEntryLog[[i]][[1]][6],
                                "h2_obs" = newEntryLog[[i]][[1]][7],
                                "h2_se" = newEntryLog[[i]][[1]][8])
    newEntryRowsTable <- rbind(newEntryRowsTable, newEntryRow)
  }
  print(newEntryRowsTable)
  
  print("STEP 10: Convert all columns to characters for further manipulation")
  newEntryRowsTable <- newEntryRowsTable %>% mutate_all(as.character)
  
  print("STEP 11: Convert rg, rg_se, rg_z, rg_p, h2_obs and h2_se to integers")
  newEntryRowsTable <- newEntryRowsTable %>% mutate_at(vars(c("rg", "rg_se", "rg_z", "rg_p","h2_obs", "h2_se")), funs(as.numeric))

  print("New entry to be added to results table")
  print(newEntryRowsTable)

  print("STEP 12: add new entry to results table")
  resultsTable <- rbind(resultsTable, newEntryRowsTable)
  print("Updated results table")
  print(resultsTable)
}

print("Final results table")
print(resultsTable)
setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Results/rg_analysis")

write.csv(resultsTable, "protein_rg_results.csv", row.names=F, quote=F)

