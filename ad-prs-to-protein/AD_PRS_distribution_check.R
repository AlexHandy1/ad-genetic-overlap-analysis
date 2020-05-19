library(data.table)
library(dplyr)

resultsTable <- data.frame()
prsFiles <- list.files(pattern = ".*.best")
anm_cases <- fread("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC/ANM_Proteins_Covariate_File.txt", header=T)

for ( prsFile in prsFiles ) {

  protein_prs_raw <- read.table(prsFile, header=T)

  start <- gsub("\\..*","", prsFile)
  end <- gsub("^.*\\.","", prsFile)
  remove_start <- gsub(start,"", prsFile)
  protein_name <- gsub(end,"", remove_start)

  print(protein_name)

  #add case status based on FID (join from phenotype dataset)
  protein_prs_with_info <- left_join(protein_prs_raw, anm_cases, by="FID")

  print(summary(protein_prs_with_info))

  ad_cases <- filter(protein_prs_with_info, AD == 2)
  mci_cases <- filter(protein_prs_with_info, AD == 1)
  controls <- filter(protein_prs_with_info, AD == 0)

  res <- data.frame(Protein = protein_name, Mean_PRS = mean(protein_prs_with_info$PRS), AD = mean(ad_cases$PRS), MCI = mean(mci_cases$PRS), CTL = mean(controls$PRS$

  res <- res %>% mutate_if(is.numeric, format, scientific=F, digits=4)

  resultsTable <- rbind(resultsTable, res)

}

write.csv(resultsTable, "AD_PRS_check_summary.csv", row.names = F)
