library(devtools)
library(TwoSampleMR)
library(dplyr)
library(data.table)

p_threshold <- 5e-08
ld_threshold <- 0.001
kb_threshold <- 250

#Read in Haptoglobin
HP_exp_dat_f <- extract_instruments(outcomes='prot-a-1369', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Read in ITIH1
ITIH1_exp_dat_f <- extract_instruments(outcomes='prot-a-1586', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Read in Plasma protease C1 inhibitor
SERPING1_exp_dat_f <- extract_instruments(outcomes='prot-a-2701', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Read in Serum amyloid P component
APCS_exp_dat_f <- extract_instruments(outcomes='prot-a-120', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Add IL10
IL10_exp_dat_f <- extract_instruments(outcomes='prot-a-1464', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Add C6
C6_exp_dat_f <- extract_instruments(outcomes='prot-a-318', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Add KLK3
KLK3_exp_dat_f <- extract_instruments(outcomes='prot-a-1661', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Add IGFBP2
IGFBP2_exp_dat_f <- extract_instruments(outcomes='prot-a-1448', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#Add APOE
APOE_exp_dat_f <- extract_instruments(outcomes='prot-a-131', p1=p_threshold, r2=ld_threshold, kb=kb_threshold)

#SETUP LOOP FOR MR
resultsTable <- data.frame()
exposures <- list(HP_exp_dat_f, 
                  ITIH1_exp_dat_f, 
                  SERPING1_exp_dat_f, 
                  APCS_exp_dat_f,  
                  IL10_exp_dat_f,
                  C6_exp_dat_f,
		  KLK3_exp_dat_f,
		  IGFBP2_exp_dat_f,
		  APOE_exp_dat_f	
                  )

my_plots2 <- vector(mode="list", length=length(exposures))

#Read in AD GWAS data
AD <- fread("/users/k1894983/Step4_MR/Prt_to_AD_MR/data/Kunkle_Stage1_post_qc.txt", header=T)

for (i in 1:(length(exposures))) {
  #Get exposure object
  exposure <- exposures[[i]]
  print(exposure$exposure)
  
  #Get exposure SNPs
  exposure_SNPs <- exposure$SNP
  print(exposure_SNPs)
  
  if ( is.null(exposure) || is.null(exposure_SNPs) ) { next }
  if ( nrow(filter(AD, MarkerName %in% exposure_SNPs)) == 0 ) { next }
  
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

      #Plot and save image results
      p1 <- mr_scatter_plot(res, dat)
      p2 <- mr_forest_plot(res_single)

      #Capture plots in list of plots
      plots <- c(p1, p2)
      my_plots2[[i]] <- plots
      
 }
    
write.csv(resultsTable, "Prot_to_AD_T2.csv", row.names=F, quote=F)




