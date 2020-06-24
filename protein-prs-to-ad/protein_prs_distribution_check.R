print("Load libraries")
library(data.table)
library(dplyr)

print("Setup results table")
resultsTable <- data.frame()

print("Load files")
setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Results/prs")

dirs <- list.files()

for (dir in dirs){
  #moved folder to within all with apoe folder
  if (dir != "archive_runs"){
    path <- paste("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Results/prs/", dir, sep="")
    setwd(path)

    prsFiles <- list.files(pattern = ".*.best")

    caseFiles <- c("ADNI_ForPRS.WITHAPOE.Original.Overlapping.fam", "ANM_ForPRS.WITHAPOE.Original.Overlapping.fam", "GERAD_ForPRS.WITHAPOE.Original.Overlapping.fam")


    for ( prsFile in prsFiles ) {
      setwd(path)
      #would need to add loop for sub groups to test prs of each subset rather than mean across subsets (OK as using as a sense check for distributions)
      print(paste("Load: ", prsFile))

      protein_prs <- read.table(prsFile, header=T)

      protein <- gsub("_.*","",prsFile)
      sample <- gsub("^[^_]*_","",prsFile)
      sample <- gsub("\\..*","",sample)

      print(protein)
      print(sample)

      print("Merge cases")
      setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Target_Data")
      if (sample == "ADNI") {

        adni <- read.table(caseFiles[1], header=T)
        names(adni) <- c("FID", "IID", "ID_Father", "ID_Mother", "Sex","Case")
        protein_prs_with_info <- left_join(protein_prs, adni, by=c("FID", "IID"))

        } else if (sample == "ANM") {

        anm <- read.table(caseFiles[2], header=T)
        names(anm) <- c("FID", "IID", "ID_Father", "ID_Mother", "Sex","Case")
        protein_prs_with_info <- left_join(protein_prs, anm, by=c("FID", "IID"))

          } else if (sample == "GERAD") {
            gerad <- read.table(caseFiles[3], header=T)
            names(gerad) <- c("FID", "IID", "ID_Father", "ID_Mother", "Sex","Case")
            protein_prs_with_info <- left_join(protein_prs, gerad, by=c("FID", "IID"))

        }

        print(summary(protein_prs_with_info))

        print("Create data frames for cases and controls")
        ad <- filter(protein_prs_with_info, Case == 2)
        controls <- filter(protein_prs_with_info, Case == 1)

        res <- data.frame(Directory = dir, Protein = protein, Sample = sample, Mean_PRS = mean(protein_prs_with_info$PRS), Max_PRS = max(protein_prs_with_info$PRS), Min_PRS = min(protein_prs_with_info$PRS), SD_PRS = sd(protein_prs_with_info$PRS), Mean_AD = mean(ad$PRS), Mean_CTL = mean(controls$PRS))

        res <- res %>% mutate_if(is.numeric, format, scientific=F, digits=4)

        resultsTable <- rbind(resultsTable, res)
    }
  }
}

setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Results/prs")
write.csv(resultsTable, "Protein_PRS_check_summary.csv", row.names = F)

