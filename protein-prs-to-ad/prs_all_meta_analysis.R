print("STEP 0: Load libraries")
library(metafor)
library(dplyr)

print("STEP 1: Load PRS Results prepared for meta analysis")
#update for with and without APOE
setwd("/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Results/prs/protein_prs_all_with_apoe")
prsResults <- read.csv("protein_prs_all_with_apoe_res_for_meta_analysis.csv", header=T)

print("STEP 2: Set total sample size for use in R^2 calculation")
#Consider adding programmatically 
ADNISampleN <- 1007
ANMSampleN <-  738 #(7 removed due to invalid age covariate data)
GERADSampleN <- 4492
totalSampleN <- (ADNISampleN + ANMSampleN + GERADSampleN)

print("STEP 3: Setup overall results table")
resultsTable <- data.frame()

print("STEP 4: Loop through the unique list of proteins")
proteins <- unique(prsResults$Protein)

for (protein in proteins){ 
  print(protein)
  
  print("STEP 5: Select data from each of the 10 thresholds")
  test1<-prsResults %>% filter(Protein == protein, Threshold == 5e-08)
  test2<-prsResults %>% filter(Protein == protein, Threshold == 5e-05)
  test3<-prsResults %>% filter(Protein == protein, Threshold == 5e-04)
  test4<-prsResults %>% filter(Protein == protein, Threshold == 0.001)
  test5<-prsResults %>% filter(Protein == protein, Threshold == 0.01)
  test6<-prsResults %>% filter(Protein == protein, Threshold == 0.05)
  test7<-prsResults %>% filter(Protein == protein, Threshold == 0.1)
  test8<-prsResults %>% filter(Protein == protein, Threshold == 0.2)
  test9<-prsResults %>% filter(Protein == protein, Threshold == 0.5)
  test10<-prsResults %>% filter(Protein == protein, Threshold == 1)
  
  #consider implementing loop to reduce repetition
  # TESTS <- c(if(exists("test1")) test1, if(exists("test2")) test2, if(exists("test3")) test3, if(exists("test4")) test4, if(exists("test5")) test5, if(exists("test6")) test6, if(exists("test7")) test7, if(exists("test8")) test8, if(exists("test9")) test9, if(exists("test10")) test10)
  # for (i in TESTS){
  #   print(i)
  # }
  
  print("STEP 6: Remove data from thresholds where there are no PRS results")
  if(nrow(test1)<1) rm(test1) & rm(testMeta1)
  if(nrow(test2)<1) rm(test2) & rm(testMeta2)
  if(nrow(test3)<1) rm(test3) & rm(testMeta3)
  if(nrow(test4)<1) rm(test4) & rm(testMeta4)
  if(nrow(test5)<1) rm(test5) & rm(testMeta5)
  if(nrow(test6)<1) rm(test6) & rm(testMeta6)
  if(nrow(test7)<1) rm(test7) & rm(testMeta7)
  if(nrow(test8)<1) rm(test8) & rm(testMeta8)
  if(nrow(test9)<1) rm(test9) & rm(testMeta9)
  if(nrow(test10)<1) rm(test10) & rm(testMeta10)
  
  print("STEP 7: Run meta analysis on each threshold")
  if(exists("test1")) test1.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test1)
  if(exists("test2")) test2.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test2)
  if(exists("test3")) test3.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test3)
  if(exists("test4")) test4.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test4)
  if(exists("test5")) test5.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test5)
  if(exists("test6")) test6.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test6)
  if(exists("test7")) test7.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test7)
  if(exists("test8")) test8.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test8)
  if(exists("test9")) test9.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test9)
  if(exists("test10")) test10.reml<-rma(yi=Coefficient, sei=Standard.Error, method="REML", data=test10)
  
  print("STEP 8: Store results for each threshold test")
  if(exists("test1")) testMeta1<-data.frame(test1$Protein[1], test1$Threshold[1], test1$Num_SNP[1], totalSampleN, test1.reml$beta, test1.reml$zval, test1.reml$pval, test1.reml$ci.lb, test1.reml$ci.ub, test1.reml$se, test1.reml$I2, test1.reml$QE, test1.reml$QEp)
  if(exists("testMeta1")) names(testMeta1)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  if(exists("test2")) testMeta2<-data.frame(test2$Protein[1], test2$Threshold[1], test2$Num_SNP[1], totalSampleN, test2.reml$beta, test2.reml$zval, test2.reml$pval, test2.reml$ci.lb, test2.reml$ci.ub, test2.reml$se, test2.reml$I2, test2.reml$QE, test2.reml$QEp)
  if(exists("testMeta2")) names(testMeta2)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  if(exists("test3")) testMeta3<-data.frame(test3$Protein[1], test3$Threshold[1], test3$Num_SNP[1], totalSampleN, test3.reml$beta, test3.reml$zval, test3.reml$pval, test3.reml$ci.lb, test3.reml$ci.ub, test3.reml$se, test3.reml$I2, test3.reml$QE, test3.reml$QEp)
  if(exists("testMeta3")) names(testMeta3)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  if(exists("test4")) testMeta4<-data.frame(test4$Protein[1], test4$Threshold[1], test4$Num_SNP[1], totalSampleN, test4.reml$beta, test4.reml$zval, test4.reml$pval, test4.reml$ci.lb, test4.reml$ci.ub, test4.reml$se, test4.reml$I2, test4.reml$QE, test4.reml$QEp)
  if(exists("testMeta4")) names(testMeta4)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  if(exists("test5")) testMeta5<-data.frame(test5$Protein[1], test5$Threshold[1], test5$Num_SNP[1], totalSampleN, test5.reml$beta, test5.reml$zval, test5.reml$pval, test5.reml$ci.lb, test5.reml$ci.ub, test5.reml$se, test5.reml$I2, test5.reml$QE, test5.reml$QEp)
  if(exists("testMeta5")) names(testMeta5)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  if(exists("test6")) testMeta6<-data.frame(test6$Protein[1], test6$Threshold[1], test6$Num_SNP[1], totalSampleN, test6.reml$beta, test6.reml$zval, test6.reml$pval, test6.reml$ci.lb, test6.reml$ci.ub, test6.reml$se, test6.reml$I2, test6.reml$QE, test6.reml$QEp)
  if(exists("testMeta6")) names(testMeta6)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  if(exists("test7")) testMeta7<-data.frame(test7$Protein[1], test7$Threshold[1], test7$Num_SNP[1], totalSampleN, test7.reml$beta, test7.reml$zval, test7.reml$pval, test7.reml$ci.lb, test7.reml$ci.ub, test7.reml$se, test7.reml$I2, test7.reml$QE, test7.reml$QEp)
  if(exists("testMeta7")) names(testMeta7)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  if(exists("test8")) testMeta8<-data.frame(test8$Protein[1], test8$Threshold[1], test8$Num_SNP[1], totalSampleN, test8.reml$beta, test8.reml$zval, test8.reml$pval, test8.reml$ci.lb, test8.reml$ci.ub, test8.reml$se, test8.reml$I2, test8.reml$QE, test8.reml$QEp)
  if(exists("testMeta8")) names(testMeta8)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  if(exists("test9")) testMeta9<-data.frame(test9$Protein[1], test9$Threshold[1], test9$Num_SNP[1], totalSampleN, test9.reml$beta, test9.reml$zval, test9.reml$pval, test9.reml$ci.lb, test9.reml$ci.ub, test9.reml$se, test9.reml$I2, test9.reml$QE, test9.reml$QEp)
  if(exists("testMeta9")) names(testMeta9)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  if(exists("test10")) testMeta10<-data.frame(test10$Protein[1], test10$Threshold[1], test10$Num_SNP[1], totalSampleN, test10.reml$beta, test10.reml$zval, test10.reml$pval, test10.reml$ci.lb, test10.reml$ci.ub, test10.reml$se, test10.reml$I2, test10.reml$QE, test10.reml$QEp)
  if(exists("testMeta10")) names(testMeta10)<-c("Protein", "Threshold", "nSNP", "Total_Sample_n", "beta", "z", "p", "ci_lower", "ci_upper", "se", "i2", "Q", "Q-p")
  
  print("STEP 9: Create summary data frame for all threshold tests for current protein")
  testMeta<-rbind(if(exists("testMeta1")) testMeta1, if(exists("testMeta2")) testMeta2, if(exists("testMeta3")) testMeta3, if(exists("testMeta4")) testMeta4, if(exists("testMeta5")) testMeta5, if(exists("testMeta6")) testMeta6, if(exists("testMeta7")) testMeta7, if(exists("testMeta8")) testMeta8, if(exists("testMeta9")) testMeta9, if(exists("testMeta10")) testMeta10)
  print(testMeta)
  
  print("STEP 10: Calculate R and R^2 and add to summary data frame")
  testMeta$r<-testMeta$z/sqrt(testMeta$Total_Sample_n-2+testMeta$z^2)
  testMeta$r2<-(testMeta$r)^2
  print(testMeta)
  
  print("STEP 11: add column to check if p value is significant at 0.05 threshold")
  testMeta <- mutate(testMeta, Significant = if_else(p < 0.05, "Y","N"))
  
  print("STEP 12: add column with P value converted to -log10")
  testMeta <- mutate(testMeta, P_MinusLog10 = -log10(p))
  
  print("STEP 13: add summary data frame for new protein entry to overall results table")
  resultsTable <- rbind(resultsTable, testMeta)
  print("Updated results table")
  print(resultsTable)
}

print("Final results table")
print(resultsTable)
write.csv(resultsTable, "protein_prs_all_with_apoe_meta_analysis_res.csv", col.names=T, row.names=F, quote=F)


