print("Step 0: Load Libraries")
library(devtools)
library(TwoSampleMR)
library(dplyr)
library(data.table)


print("Step 1: Read in Kunkle GWAS Data")
AD <- fread('/Users/alexanderhandy/Documents/MSc-Neuroscience/Thesis-data/Kunkle_Stage1_post_qc.txt', header=T) 

print("Step 2: Select 25 genome-wide significant SNPs from Kunkle Stage 1 and 2 as instruments")
#UPDATE WHEN RECEIVE FROM TEAM
AD_SNPs_rs_ids <- c("rs4844610","rs6733839","rs10933431","rs9271058","rs75932628",
                    "rs9473117","rs12539172","rs10808026","rs73223431","rs9331896",
                    "rs3740688","rs7933202","rs3851179","rs11218343","rs17125924","rs12881735",
                    "rs3752246","rs429358","rs6024870","rs7920721","rs138190086")

AD_SNPS <- filter(AD, MarkerName %in% AD_SNPs_rs_ids)

print("Step 3: Prepare colnames for MR")
AD_SNPS <- AD_SNPS[ ,3:7]
names(AD_SNPS) <- c("SNP", "effect_allele", "other_allele", "beta", "se")
exp_dat <- format_data(AD_SNPS, type="exposure")

print("Step 4: Extract outcome data for target proteins")

out_dat <- extract_outcome_data(snps = exp_dat$SNP, outcomes = c("prot-a-131", "prot-a-127", "prot-a-670", "prot-a-1179", "prot-a-1448", "prot-a-93"))

harmonise_options = c(1,2)
  for (option in harmonise_options) {
    print("Step 5: Harmonise exposure and outcome data")
    
    dat <- harmonise_data(
      exposure_dat = exp_dat, 
      outcome_dat = out_dat , action = option)
    
    print(paste("SNPs in harmonised data: ",nrow(dat)))
    
    print("Step 6: Remove SNPs that are in the APOE genomic region")
    dat <- dat[which(dat$SNP!="rs429358" & dat$SNP!="rs7412" & dat$SNP!="rs439401" & dat$SNP!="rs157594" &  dat$SNP!="rs3826688"),]
    
    print(paste("SNPs in data for MR: ",nrow(dat)))
    
    print("Step 7: Perform MR")
    res <-mr(dat,   method_list=c( "mr_ivw", "mr_egger_regression","mr_weighted_median"))
    
    print("Step 8: Perform Sensitivity Analysis")
    print("Estimate Egger intercept")
    res_pleio <- mr_pleiotropy_test(dat)
    
    print("Heterogeneity between SNPs")
    res_het <- mr_heterogeneity(dat)
    
    print("Leave one out analysis")
    res_loo <- mr_leaveoneout(dat)
    
    print("Step 9: Generate confidence intervals")
    ci_lower<-c()
    ci_upper<-c()
    
    for (i in 1:nrow(res)){
      ci_lower[i]<-res[i,7]-1.96*res[i,8]
    }
    
    for (i in 1:nrow(res)){
      ci_upper[i]<-res[i,7]+1.96*res[i,8]
    }
    res$ci_lower <- ci_lower
    res$ci_upper <- ci_upper
    
    
    print("Step 10: Create results table")
    
    print("Add Protein Names with recode")
    res <- res %>% mutate(Protein=recode(id.outcome,
                                  "prot-a-131"="Apolipoprotein E",
                                  "prot-a-127"="Apolipoprotein B-100",
                                  "prot-a-670"="C-reactive protein",
                                  "prot-a-1179"="Vitamin D-binding protein",
                                  "prot-a-1448"="Insulin-like growth factor-binding protein 2",
                                  "prot-a-93"="Angiopoietin-2"
                                  ))
    
    res_all<-left_join(res, res_het, by=c("id.outcome", "method"))
    res_all_f<-left_join(res_all, res_pleio, by=c("id.outcome"))

    res_table <- data.frame(Protein = res_all_f$Protein, NSNPs = res_all_f$nsnp, Method = res_all_f$method, B = res_all_f$b, CI_Lower = res_all_f$ci_lower, CI_Upper = res_all_f$ci_upper, P_value = res_all_f$pval.x, Egger_Intercept_P_value = res_all_f$pval.y, Q_P_value = res_all_f$Q_pval)

    res_filename <- paste("ad_to_protein_mr_", toString(option), ".csv", sep="")

    write.csv(res_table, res_filename, row.names=F, quote=F)
    
    print("Step 11: Create plots")
    
    print("Scatter plots")
    p1 <- mr_scatter_plot(res, dat)
    plot_list<-list(p1)
    
    scatter_filename <- paste("ad_to_protein_mr_scatter_", toString(option), ".pdf", sep="")
    pdf(scatter_filename)
    print(plot_list)
    dev.off()
    
    print("Loo plots")
    res_loo_plot <- mr_leaveoneout_plot(res_loo)
    plot_list2<-list(res_loo_plot)
    
    loo_filename <- paste("ad_to_protein_mr_loo_", toString(option), ".pdf", sep="")
    pdf(loo_filename)
    print(plot_list2)
    dev.off()
  }

