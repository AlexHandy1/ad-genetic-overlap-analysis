library(devtools)
library(TwoSampleMR)

#Read in Haptoglobin
HP_exp_dat <- data.frame(
  "Phenotype" = "HP",
  "SNP" = "rs217184",
  "beta" = 0.87,
  "se" = 0.03,
  "effect_allele" = "C",
  "other_allele" = "T",
  "eaf" = 0.196
)
HP_exp_dat_f <- format_data(HP_exp_dat, type="exposure")

#Read in Inter-alpha-trypsin inhibitor heavy chain H1
ITIH1_exp_dat <- data.frame(
  "Phenotype" = "ITIH1",
  "SNP" = "rs1042779",
  "beta" = -0.65,
  "se" = 0.02,
  "effect_allele" = "G",
  "other_allele" = "A",
  "eaf" = 0.369
)
ITIH1_exp_dat_f <- format_data(ITIH1_exp_dat, type="exposure")

#Read in Plasma protease C1 inhibitor
SERPING1_exp_dat <- data.frame(
  "Phenotype" = "SERPING1",
  "SNP" = "rs11229075",
  "beta" = -0.6,
  "se" = 0.03,
  "effect_allele" = "C",
  "other_allele" = "A",
  "eaf" = 0.261
)
SERPING1_exp_dat_f <- format_data(SERPING1_exp_dat, type="exposure")

#Read in Serum amyloid P component
APCS_exp_dat <- data.frame(
  "Phenotype" = "APCS",
  "SNP" = "rs71632673",
  "beta" = -0.84,
  "se" = 0.08,
  "effect_allele" = "A",
  "other_allele" = "C",
  "eaf" = 0.023
)
APCS_exp_dat_f <- format_data(APCS_exp_dat, type="exposure")

#SETUP LOOP FOR MR
resultsTable <- data.frame()
exposures <- list(HP_exp_dat_f, ITIH1_exp_dat_f, SERPING1_exp_dat_f, APCS_exp_dat_f)

for (i in 1:(length(exposures))) {
  #Get exposure object
  exposure <- exposures[[i]]
  print(exposure$exposure)
  
  #Get exposure SNPs
  exposure_SNPs <- exposure$SNP
  print(exposure_SNPs)
  
  #Setup AD outcome data
  AD_outcome_dat <- read_outcome_data(
    snps = exposure_SNPs,
    filename = "/users/k1894983/Step4_MR/Prt_to_AD_MR/data/Kunkle_Stage1_post_qc.txt",
    sep = " ",
    snp_col = "MarkerName",
    beta_col = "Beta",
    se_col = "SE",
    effect_allele_col = "Effect_allele",
    other_allele_col = "Non_Effect_allele",
    pval_col = "Pvalue"
  )
  
  #Harmonise data
  dat <- harmonise_data(
    exposure_dat = exposure,
    outcome_dat = AD_outcome_dat, 
    action=2
  )
  
  #Run MR
  res <- mr(dat)
  res_single <- mr_singlesnp(dat)
  
  #Capture results in results table
  resultsTable <- rbind(resultsTable, res)
}

write.csv(resultsTable, "Prot_to_AD_T1.csv", row.names=F, quote=F)
