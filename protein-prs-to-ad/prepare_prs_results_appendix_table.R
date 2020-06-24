print("STEP 0: Load libraries and set working directory to results")
library(dplyr)

setwd("/Users/alexanderhandy/Documents/Code/ad-genetic-overlap-web/results/step2_results")

print("STEP 1: get list of meta-analysis files and setup results table")
files <- list.files(pattern = ".*meta_analysis_res.csv")
proteins <- c("PPY.4588.1.2","APOE.2937.10.2","CFH.4159.130.1","SERPING1.4479.14.2","C3.2755.8.2","FGA.FGB.FGG.4907.56.1","APCS.2474.54.5","HP.3054.3.2","IL3.4717.55.2","C4A.C4B.4481.34.2","IL10.2773.50.2","VTN.13125.45.3","IGFBP2.2570.72.5","ANGPT2.13660.76.3","APOB.2797.56.2","CCL26.9168.31.3","CRP.4337.49.2","CLU.4542.24.2","CSF3.8952.65.3","IL13.3072.4.2","CXCL8.3447.64.2","KITLG.9377.25.3","MMP9.2579.17.5","NPPB.3723.1.2","PLG.3710.49.2","RETN.3046.31.1","TF.4162.54.2","TNC.4155.3.2","TNF.5936.53.3","VCAM1.2967.8.1","GC.6581.50.3")
results_table <- data.frame(Protein = proteins)

for (file in files) {
	print(paste("STEP 2: load meta-analysis file :", file))
	res <- read.csv(file, header=T)

	print("STEP 3: select protein name, minimum p-value and threshold")
	res <- res %>% group_by(Protein) %>% filter(p == min(p)) %>% select(Protein, Threshold, p)

	print("STEP 4: rename Threshold and p so specific to subset analysis")
	front <- substr(file,0,12)
	dist_from_back <- nchar(file) - 21 
	back <- substr(file,dist_from_back,nchar(file))
	front_removed <- gsub(front, "", file)
	analysis_group <- gsub(back, "", front_removed)

	threshold_label <- paste("T", analysis_group, sep = "_")
	p_label <- paste("P", analysis_group, sep = "_")
	colnames(res)[2] <- threshold_label
	colnames(res)[3] <- p_label

	print("STEP 5: add results to overall results table")

	results_table <- left_join(results_table, res, by=c("Protein"))
}

print("STEP 6: write results table to csv")
print(results_table)
write.csv(results_table, "protein_prs_meta_analysis_appendix_res.csv", row.names=FALSE)

