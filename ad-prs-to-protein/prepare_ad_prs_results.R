print("STEP 0: Load libraries")
library(data.table)
library(dplyr)

#alphabetical order for anm_phenotypes
print("Setup phenotype map list for later mapping")
anm_phenotyes <- c("Angiopoietin.2","Apo.B","Apo.E3","BNP.32","C1.Esterase.Inhibitor","C3","C4","Clusterin","CRP","D.dimer","Factor.H","G.CSF","Haptoglobin..Mixed.Type","IGFBP.2","IL.10","IL.13","IL.3","IL.8","MMP.9","Plasminogen","resistin","SAP","Tenascin","TNF.a","Transferrin","VCAM.1")
somamer_ids <- c("ANGPT2.13660.76.3","APOB.2797.56.2","APOE.2937.10.2","NPPB.3723.1.2","SERPING1.4479.14.2", "C3.2755.8.2","C4A.C4B.4481.34.2","CLU.4542.24.2","CRP.4337.49.2","FGA.FGB.FGG.4907.56.1","CFH.4159.130.1","CSF3.8952.65.3","HP.3054.3.2","IGFBP2.2570.72.5","IL10.2773.50.2","IL13.3072.4.2","IL3.4717.55.2","CXCL8.3447.64.2","MMP9.2579.17.5","PLG.3710.49.2","RETN.3046.31.1","APCS.2474.54.5","TNC.4155.3.2","TNF.5936.53.3","TF.4162.54.2","VCAM1.2967.8.1")
phenotype_map <- setNames(as.list(somamer_ids), anm_phenotyes)


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

		print("STEP 2: Load .summary file")
		summary_res_file <- list.files(pattern = ".*.summary")

		summary_res_table <- fread(summary_res_file, header=TRUE)

		print("STEP 3: Add Somamer ID as Protein name")
		#non-dynamic mapping approach
		summary_res_table$Protein <- somamer_ids

		print("STEP 4: add column with P value converted to -log10")
  		summary_res_table <- mutate(summary_res_table, P_MinusLog10 = -log10(P))

  		print("STEP 5: add column to check if p value is significant at 0.05 threshold")
  		summary_res_table <- mutate(summary_res_table, Significant = if_else(P < 0.05, "Y","N"))

  		print("STEP 6: add column to check if p value is significant at Bonferroni threshold")
  		bonf_threshold <- 0.00019 #0.05 / 26 * 10 (number of proteins * p-value thresholds tested)
  		summary_res_table <- mutate(summary_res_table, SignificantBonf = if_else(P < bonf_threshold, "Y","N"))

  		print("STEP 7: add adjusted p values analysis using BH and FDR of 0.1")
  		summary_res_table_final <- summary_res_table %>% mutate(adjp = p.adjust(P, method="BH")) %>% mutate(adjp_MinusLog10 = -log10(adjp)) %>% mutate(SignificantAdjP = if_else(adjp < 0.1, "Y","N")) 

  		print("STEP 8: Write results table to csv")
  		print(summary_res_table_final)
		res_file_name <- paste("ad_prs_",tolower(strat), "_",tolower(status),"_res.csv",sep="")

		print(res_file_name)
		setwd("/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_Protein/Results")
		write.csv(summary_res_table_final, res_file_name, row.names=F, quote=F)

	}
}