print("STEP 0: Load libraries")
library(data.table)
library(dplyr)

print("STEP 1: Setup loop for results directories")

apoe_status <- c("WITH_APOE", "NO_APOE")

strats <- c("ALL", "MALES_ONLY", "FEMALES_ONLY", "65_AND_OVER", "70_AND_OVER", "75_AND_OVER", "80_AND_OVER")

directory_prefix <- "/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Results/AD_PRS_"

for (status in apoe_status){
	for (strat in strats) {
		directory <- paste(directory_prefix, status, "_", strat,sep="")
		print(directory)
		setwd(directory)
		print(paste("Loading files from: ", directory))

		print("STEP 2: Load .prsice file")
		summary_res_file <- list.files(pattern = ".*.prsice")

		summary_res_table <- fread(summary_res_file, header=TRUE)

		print("STEP 3: add column with P value converted to -log10")
  		summary_res_table <- mutate(summary_res_table, P_MinusLog10 = -log10(P))

  		print("STEP 4: add column to check if p value is significant at 0.05 threshold")
  		summary_res_table <- mutate(summary_res_table, Significant = if_else(P < 0.05, "Y","N"))

  		print("STEP 5: add column to check if p value is significant at Bonferroni threshold")
  		bonf_threshold <- 0.00019 #0.05 / 26 * 10 (number of proteins * p-value thresholds tested)
  		summary_res_table <- mutate(summary_res_table, SignificantBonf = if_else(P < bonf_threshold, "Y","N"))

  		print("STEP 6: add adjusted p values analysis using BH and FDR of 0.1")
  		summary_res_table_final <- summary_res_table %>% mutate(adjp = p.adjust(P, method="BH")) %>% mutate(adjp_MinusLog10 = -log10(adjp)) %>% mutate(SignificantAdjP = if_else(adjp < 0.1, "Y","N")) 

  		print("STEP 7: Write results table to csv")
  		print(summary_res_table_final)
		res_file_name <- paste("ad_prs_",tolower(strat), "_",tolower(status),"_res.csv",sep="")

		print(res_file_name)
		setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Results")
		write.csv(summary_res_table_final, res_file_name, row.names=F, quote=F)

	}
}