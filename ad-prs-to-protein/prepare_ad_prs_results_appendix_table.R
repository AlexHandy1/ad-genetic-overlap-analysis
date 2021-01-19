print("STEP 0: Load libraries and set working directory to results")
library(dplyr)

setwd("/Users/alexanderhandy/Documents/Code/ad-genetic-overlap-web/results/step3_results")

print("STEP 1: get list of results files and setup results table")
#files <- list.files(pattern = ".*_res.csv")
files <- c("ad_prs_all_with_apoe_res.csv", "ad_prs_all_no_apoe_res.csv", "ad_prs_males_only_with_apoe_res.csv", "ad_prs_males_only_no_apoe_res.csv", "ad_prs_females_only_with_apoe_res.csv", "ad_prs_females_only_no_apoe_res.csv", "ad_prs_70_and_over_with_apoe_res.csv", "ad_prs_70_and_over_no_apoe_res.csv")
anm_phenotyes <- c("Angiopoietin.2","Apo.B","Apo.E3","BNP.32","C1.Esterase.Inhibitor","C3","C4","Clusterin","CRP","D.dimer","Factor.H","G.CSF","Haptoglobin..Mixed.Type","IGFBP.2","IL.10","IL.13","IL.3","IL.8","MMP.9","Plasminogen","resistin","SAP","Tenascin","TNF.a","Transferrin","VCAM.1")
somamer_ids <- c("ANGPT2.13660.76.3","APOB.2797.56.2","APOE.2937.10.2","NPPB.3723.1.2","SERPING1.4479.14.2", "C3.2755.8.2","C4A.C4B.4481.34.2","CLU.4542.24.2","CRP.4337.49.2","FGA.FGB.FGG.4907.56.1","CFH.4159.130.1","CSF3.8952.65.3","HP.3054.3.2","IGFBP2.2570.72.5","IL10.2773.50.2","IL13.3072.4.2","IL3.4717.55.2","CXCL8.3447.64.2","MMP9.2579.17.5","PLG.3710.49.2","RETN.3046.31.1","APCS.2474.54.5","TNC.4155.3.2","TNF.5936.53.3","TF.4162.54.2","VCAM1.2967.8.1")
results_table <- data.frame(Protein = somamer_ids, Pheno = anm_phenotyes)

for (file in files) {
	print(paste("STEP 2: load meta-analysis file :", file))
	res <- read.csv(file, header=T)

	print("STEP 3: select protein name, p-value and threshold")
	res <- res %>% group_by(Pheno) %>% filter(R2 == max(R2)) %>% select(Pheno, Threshold, R2, P)

	print("STEP 4: rename Threshold and p so specific to subset analysis")
	front <- substr(file,0,7)
	dist_from_back <- nchar(file) - 7
	back <- substr(file,dist_from_back,nchar(file))
	front_removed <- gsub(front, "", file)
	analysis_group <- gsub(back, "", front_removed)

	threshold_label <- paste("T", analysis_group, sep = "_")
	r_label <- paste("R2", analysis_group, sep = "_")
	p_label <- paste("P", analysis_group, sep = "_")
	colnames(res)[2] <- threshold_label
	colnames(res)[3] <- r_label
	colnames(res)[4] <- p_label

	print("STEP 5: add results to overall results table")

	results_table <- left_join(results_table, res, by=c("Pheno"))
}

print("STEP 6: write results table to csv")
print(results_table)
write.csv(results_table, "ad_prs_appendix_res.csv", row.names=FALSE)

