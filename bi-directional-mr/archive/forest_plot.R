library(devtools)
#version 0.5.4 (update available - hold)
library(TwoSampleMR)
library(dplyr)
library(data.table)

calcFstat <- function(beta, se) {
  beta = as.numeric(beta)
  se = as.numeric(se)
  Fstat <- (beta*beta) / (se*se)
  return(Fstat)
}

p_threshold <- 5e-06
ld_threshold <- 0.001
kb_threshold <- 250
option <- 2

#Exposure proteins
exp_dat <- extract_instruments(outcomes = c("prot-a-131", "prot-a-127", "prot-a-670", "prot-a-1179", "prot-a-1448"),p1=p_threshold,r2=ld_threshold,kb=kb_threshold)
print(paste("Total exposure SNPs loaded: ",nrow(exp_dat)))

print("Calculate F statistics and remove")
print(paste("Total exposure SNPs before F stat check: ",nrow(exp_dat)))
#Create F stat
exp_dat["F"] <- apply(exp_dat,1, function(x) calcFstat(x["beta.exposure"], x["se.exposure"]))
#Remove SNPs with F stat < 10
exp_dat = exp_dat %>% filter(F > 10)
#Drop F stat column 
exp_dat = exp_dat %>% select(-F)
print(paste("Total exposure SNPs after F stat check: ",nrow(exp_dat)))

print("Step 2: Remove SNPs that are associated with multiple proteins")
exp_dat <- exp_dat[!(duplicated(exp_dat$SNP)|duplicated(exp_dat$SNP, fromLast=TRUE)),, drop=FALSE]
print(paste("Unique exposure SNPs: ",nrow(exp_dat)))

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
  outcome_dat = out_dat , action = option)

print(paste("SNPs in harmonised data: ",nrow(dat)))

print("Step 6: Remove SNPs that are in the APOE genomic region")
dat <- dat[which(dat$SNP!="rs429358" & dat$SNP!="rs7412" & dat$SNP!="rs439401" & dat$SNP!="rs157594" &  dat$SNP!="rs3826688"),]

print(paste("SNPs in data for MR: ",nrow(dat)))

print("Step 7: Perform MR")
res <-mr(dat,   method_list=c( "mr_ivw", "mr_egger_regression","mr_weighted_median"))

print(res)

print("Step 8: Print forest plot")

print("Format protein names")

res <- res %>% mutate(Protein=recode(id.exposure,
                                     "prot-a-131"="APOE ε3",
                                     "prot-a-127"="APOB-100", 
                                     "prot-a-670"="CRP",
                                     "prot-a-1179"="VDBP",
                                     "prot-a-1448"="IGFBP2"
))

print("Format p-values")
res$pval<-format(res$pval, format = "e", digits = 2)

print("Order alphabetically by protein")
res <- res[order(res$Protein),]

print("Change inverse variance weighted to IVW")
replace_ivw <- function(x) gsub('Inverse variance weighted', 'IVW', x)
res$method <- lapply(res$method, replace_ivw)

print("Plot and save the image")
plot_filename <- paste("protein_to_ad_mr_forest_", toString(p_threshold), "_",  toString(option), ".tiff", sep="")
tiff(plot_filename, width = 5.3, height = 5.2, units = "in", res = 300)

forest_plot_1_to_many(res,
                      b="b",
                      se="se",
                      exponentiate=T,
                      ao_slc=F,
                      col1_width=1.7,
                      by="Protein",
                      TraitM="method",
                      xlab="AD OR per SD increase in exposure (95% CI)",
                      addcols=c("nsnp",
                                "pval"),
                      addcol_widths=c(0.75,
                                      0.75),
                      addcol_titles=c("SNPs (N)",
                                      "P-value"),
                      shape_points = 16,
                      col_text_size = 2.5, 
                      subheading_size = 7,
                      )

dev.off()


#TO-DO
  #Add loop for all options
  #Confirm weighted median accuracy (add to previous pipeline, and re-run)
  #Scope adding charts to web app

