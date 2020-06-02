print("STEP 0: Load libraries")
library(dplyr)
library(tibble)

print("STEP 1: Load .log files")
print("Set working directory to heritability_check/h2")
setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/heritability_analysis/Final_Shortlist/h2")
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
  newEntryLog <- slice(newEntryLog, 24:28)

  print("STEP 7: Split out label from data")
  #split data on : in each row
  newEntryLog <- apply(newEntryLog, 1, function(x) strsplit(x, ":"))

  print("STEP 8: Set labels as column headers and pair with relevant data")

  newEntryLogDF <- data.frame("h2" = newEntryLog[[1]][[1]][2],
                              "Lambda_GC" = newEntryLog[[2]][[1]][2],
                              "Mean_Chi_^2" = newEntryLog[[3]][[1]][2],
                              "Intercept" = newEntryLog[[4]][[1]][2],
                              "Ratio" = newEntryLog[[5]][[1]][2]
                              )
  
  print("STEP 9: add protein name to new entry")
  newEntryLogDF <- add_column(newEntryLogDF, Protein=protein, .before=1)

  print("STEP 10: Convert all columns to characters for further manipulation")
  newEntryLogDF <- newEntryLogDF %>% mutate_all(as.character)
  
  print("STEP 11: Remove white spaces in each column")
  
  remove_whitespace <- function(x) gsub("\\s", "", x)
  newEntryLogDF <- newEntryLogDF %>% mutate_all(remove_whitespace)
  
  print("STEP 12: Remove text in brackets and add remaining text to new columns")
  remove_brackets_text <- function(x) gsub("\\s*\\([^\\)]+\\)","", x)
  
  get_text_in_brackets <- function(x) gsub("[\\(\\)]", "", regmatches(x, gregexpr("\\(.*?\\)", x)))[[1]]
  
  newEntryLogDF <- newEntryLogDF %>% mutate(h2_no_se = remove_brackets_text(h2), 
                                            h2_se = get_text_in_brackets(h2),
                                            intercept_no_se = remove_brackets_text(Intercept), 
                                            intercept_se = get_text_in_brackets(Intercept),
                                            ratio_no_se = remove_brackets_text(Ratio),
                                            ratio_se = get_text_in_brackets(Ratio))
  
  print("STEP 13: Convert h2_no_error, intercept_no_error and ratio_no_error to integers")
  newEntryLogDF <- newEntryLogDF %>% mutate_at(vars(c("h2_no_se", "h2_se", "intercept_no_se", "intercept_se","ratio_no_se", "ratio_se")), funs(as.numeric))
  
  print("New entry to be added to results table")
  print(newEntryLogDF)

  print("STEP 14: add new entry to results table")
  resultsTable <- rbind(resultsTable, newEntryLogDF)
  print("Updated results table")
  print(resultsTable)
}

print("Final results table")
print(resultsTable)

setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Results/heritability_analysis")
write.csv(resultsTable, "protein_h2_results.csv", row.names=FALSE)

 
