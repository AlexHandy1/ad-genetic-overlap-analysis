library(dplyr)

anm <- read.csv("SOMA_ANM_RESIDUALS_NO_STATUS_LOG2_all_Sep19.csv", header=T)
anm_minus_prot <- anm[ ,0:8]

#
anm_sample_table <- anm_minus_prot %>% group_by(baseline_diag) %>% summarise(Male = sum(gender=="M"), Female = sum(gender=="F"), Mean_Age = mean(age))
