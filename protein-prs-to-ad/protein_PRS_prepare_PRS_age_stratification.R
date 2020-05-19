print("Load libraries and files")
library(data.table)
library(dplyr)

setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data/Fixed_Covariate_Files")

samples <- c("ADNI", "ANM", "GERAD")

for (sample in samples){
  print(paste("Load data for", sample))
  sampleFile <- paste(sample, "_COVARIATE_FILE.txt", sep="")
  sample_data <- read.table(sampleFile, header=T)

  print("Check counts of different AGE brackets")
  br <- seq(-10,120,by=5)
  freq <- hist(sample_data$AGE, breaks=br, include.lowest=TRUE, plot=FALSE)
  ranges <- paste(head(br+1,-1), br[-1], sep=" - ")
  AGE_count <- data.frame(range = ranges, frequency = freq$counts)
  print(AGE_count)

  print("Select FID and IIDs for 65 and over")
  SixtyFiveIDs <- sample_data %>% filter(AGE > 64) %>% select(FID, IID)
  paste("Count: ", nrow(filter(sample_data, AGE > 64)))

  print("Create .txt file with 65 and over IDs")
  fnSixtyFive <- paste(sample, "_65.txt", sep="")
  write.table(SixtyFiveIDs, file = fnSixtyFive, quote = FALSE, row.names = FALSE, col.names = FALSE)

  print("Select FID and IIDs for 70 and over")
  SeventyIDs <- sample_data %>% filter(AGE > 69) %>% select(FID, IID)
  paste("Count: ", nrow(filter(sample_data, AGE > 69)))

  print("Create .txt file with 70 and over IDs")
  fnSeventy <- paste(sample, "_70.txt", sep="")
  write.table(SeventyIDs, file = fnSeventy, quote = FALSE, row.names = FALSE, col.names = FALSE)

  print("Select FID and IIDs for 75 and over")
  SeventyFiveIDs <- sample_data %>% filter(AGE > 74) %>% select(FID, IID)
  paste("Count: ", nrow(filter(sample_data, AGE > 74)))

  print("Create .txt file with 75 and over IDs")
  fnSeventyFive <- paste(sample, "_75.txt", sep="")
  write.table(SeventyFiveIDs, file = fnSeventyFive, quote = FALSE, row.names = FALSE, col.names = FALSE)

  print("Select FID and IIDs for 80 and over")
  EightyIDs <- sample_data %>% filter(AGE > 79) %>% select(FID, IID)
  paste("Count: ", nrow(filter(sample_data, AGE > 79)))

  print("Create .txt file with 80 and over IDs")
  fnEighty <- paste(sample, "_80.txt", sep="")
  write.table(EightyIDs, file = fnEighty, quote = FALSE, row.names = FALSE, col.names = FALSE)

}

