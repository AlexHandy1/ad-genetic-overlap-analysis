library(devtools)
library(TwoSampleMR)
library(data.table)
library(dplyr)

#Read in Kunkle File
AD <- fread('/users/k1894983/Step4_MR/AD_to_Prt_MR/data/Kunkle_Stage1_post_qc.txt', header=T) 

#Select genome-wide significant SNPs from Kunkle as instruments
AD_SNPs_rs_ids <- c("rs4844610","rs6733839","rs10933431","rs9271058","rs75932628",
             "rs9473117","rs12539172","rs10808026","rs73223431","rs9331896",
             "rs3740688","rs7933202","rs3851179","rs11218343","rs17125924","rs12881735",
             "rs3752246","rs429358","rs6024870","rs7920721","rs138190086")

AD_SNPS <- filter(AD, MarkerName %in% AD_SNPs_rs_ids)

#Prepare colnames for MR Base
AD_SNPS <- AD_SNPS[ ,3:7]
names(AD_SNPS) <- c("SNP", "effect_allele", "other_allele", "beta", "se")

AD_exp_dat <- format_data(AD_SNPS, type="exposure")

#Setup outcome data for each protein
HP_out_dat <- extract_outcome_data(
  snps = AD_exp_dat$SNP,
  outcomes = 'prot-a-1369'
)

ITIH1_out_dat <- extract_outcome_data(
  snps = AD_exp_dat$SNP,
  outcomes = 'prot-a-1586'
)

SERPING1_out_dat <- extract_outcome_data(
  snps = AD_exp_dat$SNP,
  outcomes = 'prot-a-2701'
)

APCS_out_dat <- extract_outcome_data(
  snps = AD_exp_dat$SNP,
  outcomes = 'prot-a-120'
)

APOE_out_dat <- extract_outcome_data(
  snps = AD_exp_dat$SNP,
  outcomes = 'prot-a-131'
)

IL10_out_dat <- extract_outcome_data(
  snps = AD_exp_dat$SNP,
  outcomes = 'prot-a-1464'
)

C6_out_dat <- extract_outcome_data(
  snps = AD_exp_dat$SNP,
  outcomes = 'prot-a-318'
)

KLK3_out_dat <- extract_outcome_data(
  snps = AD_exp_dat$SNP,
  outcomes = 'prot-a-1661'
)

IGFBP2_out_dat <- extract_outcome_data(
  snps = AD_exp_dat$SNP,
  outcomes = 'prot-a-1448'
)

#SETUP LOOP FOR MR
resultsTable <- data.frame()
outcomes <- list(HP_out_dat, ITIH1_out_dat, SERPING1_out_dat, APCS_out_dat, APOE_out_dat, IL10_out_dat, C6_out_dat, KLK3_out_dat, IGFBP2_out_dat)
my_plots <- vector(mode="list", length=length(outcomes))

for (i in 1:(length(outcomes))) {
  #Get outcome object
  outcome <- outcomes[[i]]
  print(outcome$outcome)
  
  #Harmonise data
  dat <- harmonise_data(
    exposure_dat = AD_exp_dat,
    outcome_dat = outcome, 
    action=2
  ) 
  
  res <- mr(dat)
  res_single <- mr_singlesnp(dat)
  
  #Capture results in results table
  resultsTable <- rbind(resultsTable, res)
  
  p1 <- mr_scatter_plot(res, dat)
  p2 <- mr_forest_plot(res_single)
  
  #Capture plots in list of plots
  plots <- c(p1, p2)
  my_plots[[i]] <- plots
}

write.csv(resultsTable, "AD_to_Prot.csv", row.names=F, quote=F)
