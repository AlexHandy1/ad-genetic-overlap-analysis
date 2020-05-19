print("Load libraries and files")
library(data.table)
library(dplyr)

print("Load background ANM data")
setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC")

anm_info <- read.csv("ANM_Proteins_With_Sample_Info.csv", header=T)

print("Check counts of different age brackets")

br <- seq(50,100,by=5)
freq <- hist(anm_info$age, breaks=br, include.lowest=TRUE, plot=FALSE)
ranges <- paste(head(br+1,-1), br[-1], sep=" - ")
age_count <- data.frame(range = ranges, frequency = freq$counts)
print(age_count)

print("Select FID and IIDs for 65 and over")
SixtyFiveIDs <- anm_info %>% filter(age > 64) %>% select(FID, IID)

paste("Count: ", nrow(filter(anm_info, age > 64)))

print("Create .txt file with 65 and over IDs")
write.table(SixtyFiveIDs, file = "ANM_65.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

print("Select FID and IIDs for 70 and over")
SeventyIDs <- anm_info %>% filter(age > 69) %>% select(FID, IID)
paste("Count: ", nrow(filter(anm_info, age > 69)))

print("Create .txt file with 70 and over IDs")
write.table(SeventyIDs, file = "ANM_70.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

print("Select FID and IIDs for 75 and over")
SeventyFiveIDs <- anm_info %>% filter(age > 74) %>% select(FID, IID)
paste("Count: ", nrow(filter(anm_info, age > 74)))

print("Create .txt file with 75 and over IDs")
write.table(SeventyFiveIDs, file = "ANM_75.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

print("Select FID and IIDs for 80 and over")
EightyIDs <- anm_info %>% filter(age > 79) %>% select(FID, IID)
paste("Count: ", nrow(filter(anm_info, age > 79)))

print("Create .txt file with 80 and over IDs")
write.table(EightyIDs, file = "ANM_80.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
