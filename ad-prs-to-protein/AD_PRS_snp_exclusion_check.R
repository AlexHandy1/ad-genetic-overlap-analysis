snp_check <- function(threshold) {

library(data.table)
library(dplyr)
library(TwoSampleMR)

#get list of SNPs in AD PRS (ANM Target Data as proxy)
anm <- fread("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Target_Data/Post_QC/ANM_3B_WITH_APOE.bim", header=T)
k <- fread("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Base_Data/Post_QC/Kunkle_Stage1_post_qc.txt", header=T)
names(anm) <- c("Chromosome", "SNP", "na", "bp", "A1", "A2")
  
#Start with significant proteins where already have codes and extend if significant
proteins <- c('prot-a-1369', 'prot-a-1586', 'prot-a-2701', 
              'prot-a-120', 'prot-a-1464', 'prot-a-318', 'prot-a-1661', 
              'prot-a-1448', 'prot-a-131')

resultsTable <- data.frame()

for (i in proteins) { 
  print(i) 
  #get list of SNPs below 5e-08 for each protein in Sun-et-al (default clumping and LD)
  protein_data <- extract_instruments(outcomes=i, p1=threshold) 
  protein_snps <- protein_data$SNP
  
  #check % of SNPs included for each protein
  protein_snps_included_anm <- filter(anm, SNP %in% protein_snps)
  protein_snps_included_k <- filter(k, MarkerName %in% protein_snps)
  
  
  res <- data.frame(Protein = i, Pct_inc_anm = nrow(protein_snps_included_anm) / length(protein_snps), Pct_inc_k = nrow(protein_snps_included_k) / length(protein_snps))
  resultsTable <- rbind(res, resultsTable)
}

return(resultsTable)

}
