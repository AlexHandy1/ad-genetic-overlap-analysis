print("STEP 0: Load libraries")
library(data.table)
library(dplyr)
library(tibble)

apoe_status <- c("_with_apoe", "_no_apoe")
strats <- c("Males", "Females", "65.And.Over", "70.And.Over", "75.And.Over", "80.And.Over")

for (apoe in apoe_status) {

  print("STEP 1: Load prsice files")
  print(paste("Set working directory to PRS Outputs for: ", apoe))

  directory <- paste("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Results/prs/protein_prs_stratified",apoe,sep="")

  setwd(directory)

  for (strat in strats) {

    strat_file_pattern <- paste(".*.",strat,".prsice", sep="")

    summaryResultsFiles <- list.files(pattern = strat_file_pattern)

    print(paste("STEP 2: Setup results table for: ", strat))
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
      newEntrySummary <- select(newEntrySummary, 2:9)
      
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

    output_file <- paste("protein_prs_",strat,apoe,"_res_for_meta_analysis.csv",sep="")

    write.csv(resultsTable, output_file, col.names=T, row.names=F, quote=F)
  }
}
