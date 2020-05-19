#load packages
library(dplyr)
library(data.table)

#create a table of results
res <- data.frame()

#set working directory to covariate files
setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data/Fixed_Covariate_Files")

#load files
sampleFiles <- list.files(pattern = ".*.txt")

for (sampleFile in sampleFiles) {
  print(sampleFile)
  sample_cov <- read.table(sampleFile, header=T)
  sample_name <- gsub("_.*","",sampleFile)

  #add in status data
  setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data")
  sample_status_file <- paste(sample_name, "_ForPRS.WITHAPOE.Original.Overlapping.fam", sep="")
  sample_status <- read.table(sample_status_file, header=T)
  names(sample_status) <- c("FID", "IID", "ID_Father", "ID_Mother", "Sex", "Case")

  sample <- left_join(sample_cov, sample_status, by=c("FID", "IID"))

  #check for sex disparity
  sample <- sample %>% mutate(Sex_Check = Sex == SEX)
  sum(sample$Sex_Check, na.rm=T)

  #expand case and sex status
  sample <- sample %>% mutate(Case_Full = case_when(Case == 1 ~ "CTL" , Case == 2 ~ "AD")) %>% mutate(Case_ROC = case_when(Case == 1 ~ 0 , Case == 2 ~ 1)) %>% mutate(Sex_Full = case_when(SEX == 1 ~ "Male", SEX == 2 ~ "Female"))
  females <- filter(sample, Sex_Full == "Female")
  males <- filter(sample, Sex_Full == "Male")

  #setup data frame with target datapoints

  sampleRes <- data.frame(Sample = sample_name, Total = nrow(sample), Cases = nrow(filter(sample, Case_Full == "AD")), Controls = nrow(filter(sample, Case_Full == "CTL")), Mean_Age = mean(sample$AGE), Females = nrow(females), Males = nrow(males), Mean_Age_Female = mean(females$AGE), Mean_Age_Male = mean(males$AGE))

  print(sampleRes)
  res <- rbind(res, sampleRes)
  setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data/Fixed_Covariate_Files")
}
print(res)



