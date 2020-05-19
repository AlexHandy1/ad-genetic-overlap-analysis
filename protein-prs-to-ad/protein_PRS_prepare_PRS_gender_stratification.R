print("Load libraries and files")
library(data.table)
library(dplyr)

setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data")

samples <- c("ADNI", "ANM", "GERAD")

for (sample in samples){
   print(paste("Load data for", sample))
   sampleFile <- paste(sample, "_ForPRS.WITHAPOE.Original.Overlapping.fam", sep="")
   sample_data <- read.table(sampleFile)
   names(sample_data) <- c("FID", "IID", "ID_Father", "ID_Mother", "Sex","Case")

   print("Select FID and IIDs for Females")
   femaleIDs <- sample_data %>% filter(Sex == 2) %>% select(FID, IID)

   print("Create .txt file with Female IDs")
   outputFileFemales <- paste(sample, "_Females.txt", sep="")
   print(outputFileFemales)

   write.table(femaleIDs, file = outputFileFemales, quote = FALSE, row.names = FALSE, col.names = FALSE)

   print("Select FID and IIDs for Males")
   maleIDs <- sample_data %>% filter(Sex == 1) %>% select(FID, IID)

   print("Create .txt file with Male IDs")
   outputFileMales <- paste(sample, "_Males.txt", sep="")
   write.table(maleIDs, file = outputFileMales, quote = FALSE, row.names = FALSE, col.names = FALSE)
}
