print("Step 0: Load Libraries")
library(devtools)
library(TwoSampleMR)
library(dplyr)
library(data.table)

print("Step 1: Select SNPs for protein exposures that pass GWS")
p_threshold <- 5e-08
ld_threshold <- 0.001
kb_threshold <- 250

#Exposure proteins
exp_dat <- extract_instruments(outcomes = c("prot-a-131", "prot-a-127", "prot-a-670", "prot-a-1179", "prot-a-1448", "prot-a-93"),p1=p_threshold,r2=ld_threshold,kb=kb_threshold)
print(paste("Total exposure SNPs loaded: ",nrow(exp_dat)))

print("Step 2: Remove SNPs that are associated with multiple proteins")
exp_dat <- exp_dat[!(duplicated(exp_dat$SNP)|duplicated(exp_dat$SNP, fromLast=TRUE)),, drop=FALSE]
print(paste("Unique exposure SNPs: ",nrow(exp_dat)))

print("Step 3: Load AD outcome data")

out_dat <- read_outcome_data(
  snps = exp_dat$SNP,
  filename = "/Users/alexanderhandy/Documents/MSc-Neuroscience/Thesis-data/Kunkle_Stage1_post_qc.txt",
  sep = " ",
  snp_col = "MarkerName",
  beta_col = "Beta",
  se_col = "SE",
  effect_allele_col = "Effect_allele",
  other_allele_col = "Non_Effect_allele",
  pval_col = "Pvalue"
)

print(paste("Exposure SNPs in outcome data: ",nrow(out_dat)))

print("Step 4: Remove SNPs that are associated with AD directly")
out_dat <- out_dat %>% filter(pval.outcome > 5e-08)

print(paste("Exposure SNPs in outcome data > 5e-08 with outcome: ",nrow(out_dat)))

print("Step 5: Harmonise exposure and outcome data [Assuming all alleles on forward strand]")

dat <- harmonise_data(
  exposure_dat = exp_dat, 
  outcome_dat = out_dat , action = 1)

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

print("Step 9: Generate odds ratio and confidence intervals")
res$OR<-c(as.numeric(exp(res$b)))
ci_lower<-c()
ci_upper<-c()

for (i in 1:nrow(res)){
  ci_lower[i]<-exp(res[i,7]-1.96*res[i,8])
}

for (i in 1:nrow(res)){
  ci_upper[i]<-exp(res[i,7]+1.96*res[i,8])
}
res$ci_lower <- ci_lower
res$ci_upper <- ci_upper


print("Step 10: Create results table")

print("Add Protein Names with recode")
res <- res %>% mutate(Protein=recode(id.exposure,
                              "prot-a-131"="Apolipoprotein E",
                              "prot-a-127"="Apolipoprotein B-100", 
                              "prot-a-670"="C-reactive protein",
                              "prot-a-1179"="Vitamin D-binding protein",
                              "prot-a-1448"="Insulin-like growth factor-binding protein 2",
                              "prot-a-93"="Angiopoietin-2"
                              ))

res_all<-left_join(res, res_het, by=c("id.exposure", "method"))
res_all_f<-left_join(res_all, res_pleio, by=c("id.exposure"))

res_table <- data.frame(Protein = res_all_f$Protein, NSNPs = res_all_f$nsnp, Method = res_all_f$method, OR = res_all_f$OR, CI_Lower = res_all_f$ci_lower, CI_Upper = res_all_f$ci_upper, P_value = res_all_f$pval.x, Egger_Intercept_P_value = res_all_f$pval.y, Q_P_value = res_all_f$Q_pval)

#res_filename <- paste("protein_to_ad_mr_", toString(threshold), "_",  toString(option), ".csv", sep="")

#write.csv(res_table, res_filename, row.names=F, quote=F)

print("Step 11: Create plots")

print("Scatter plots")
p1 <- mr_scatter_plot(res, dat)
plot_list<-list(p1)

scatter_filename <- paste("protein_to_ad_mr_scatter", toString(p_threshold), "_",  toString(1), ".pdf", sep="")
pdf(scatter_filename)
plot_list
dev.off()

print("Loo plots")
res_loo_plot <- mr_leaveoneout_plot(res_loo)
plot_list2<-list(res_loo_plot)

loo_filename <- paste("protein_to_ad_mr_loo", toString(p_threshold), "_",  toString(1), ".pdf", sep="")
pdf(loo_filename)
plot_list2
dev.off()

#FOR INDIVIDUAL PROTEIN ANALYSES
#Apolipoprotein E (Search term in https://gwas.mrcieu.ac.uk: Apolipoprotein E)
#APOE3_exp_dat <- extract_instruments(outcomes='prot-a-131', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Apolipoprotein B-100 (Search term in https://gwas.mrcieu.ac.uk: Apolipoprotein B)
#APOB_exp_dat <- extract_instruments(outcomes='prot-a-127', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#C-reactive protein (Search term in https://gwas.mrcieu.ac.uk: C-reactive protein)
#CRP_exp_dat <- extract_instruments(outcomes='prot-a-670', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Vitamin D-binding protein (Search term in https://gwas.mrcieu.ac.uk: Vitamin D-binding protein)
#VITD_exp_dat <- extract_instruments(outcomes='prot-a-1179', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Insulin-like growth factor-binding protein 2 (Search term in https://gwas.mrcieu.ac.uk: Insulin-like growth factor-binding protein 2)
#IGFBP2_exp_dat <- extract_instruments(outcomes='prot-a-1448', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Angiopoietin-2 (Search term in https://gwas.mrcieu.ac.uk: Angiopoietin-2 -> 2 probes with same UniProt ID, selected prot-a-93 for analysis as most likely to correspond to ANGPT2.13660.76.3 (included in analysis) which occurs before ANGPT2.2602.2.2)
#ANG2_exp_dat <- extract_instruments(outcomes='prot-a-93', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)
