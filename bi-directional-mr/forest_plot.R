library(devtools)
#version 0.5.4 (update available - hold)
library(TwoSampleMR)
library(dplyr)
library(data.table)

p_threshold <- 5e-06
ld_threshold <- 0.001
kb_threshold <- 250

#Exposure proteins
exp_dat <- extract_instruments(outcomes = c("prot-a-131", "prot-a-127", "prot-a-670", "prot-a-1179", "prot-a-1448"),p1=p_threshold,r2=ld_threshold,kb=kb_threshold)
print(paste("Total exposure SNPs loaded: ",nrow(exp_dat)))

print("Step 2: Remove SNPs that are associated with multiple proteins")
exp_dat <- exp_dat[!(duplicated(exp_dat$SNP)|duplicated(exp_dat$SNP, fromLast=TRUE)),, drop=FALSE]
print(paste("Unique exposure SNPs: ",nrow(exp_dat)))

out_dat <- read_outcome_data(
  snps = exp_dat$SNP,
  filename = "/Users/alexanderhandy/Documents/academia/kcl-msc-neuroscience/thesis-data/Kunkle_Stage1_post_qc.txt",
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

print("Step 5: Harmonise exposure and outcome data")

dat <- harmonise_data(
  exposure_dat = exp_dat, 
  outcome_dat = out_dat , action = 2)

print(paste("SNPs in harmonised data: ",nrow(dat)))

print("Step 6: Remove SNPs that are in the APOE genomic region")
dat <- dat[which(dat$SNP!="rs429358" & dat$SNP!="rs7412" & dat$SNP!="rs439401" & dat$SNP!="rs157594" &  dat$SNP!="rs3826688"),]

print(paste("SNPs in data for MR: ",nrow(dat)))

print("Step 7: Perform MR")
res <-mr(dat,   method_list=c( "mr_ivw", "mr_egger_regression","mr_weighted_median"))

print(res)

print("Step 8: Print forest plot")

forest_plot_1_to_many(res,
                      b="b",
                      se="se",
                      exponentiate=T,
                      ao_slc=F,
                      col1_width=1.7,
                      by="exposure",
                      TraitM="method",
                      xlab="OR for AD per SD increase in risk factor (95% confidence interval)",
                      addcols=c("nsnp",
                                "pval"),
                      addcol_widths=c(1.0,
                                      0.8),
                      addcol_titles=c("No. SNPs",
                                      "P-val"),
                      col_text_size = 2)

#TO-DO
  #Update exposure names
  #Fix p value to 2 dcp
  #Lower size of of OR plots (and check accuracy)
  #Save as images / pdfs
  #Add loop for all options
  #Scope adding charts to web app

