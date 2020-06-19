### Overview of analysis pipeline for MR

#### Protein to AD MR

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/bi-directional-mr/protein_to_ad_mr.R) to perform MR with selected proteins as the exposure and AD as the outcome. Instrumental SNPs for proteins selected and tested at 2 p-value thresholds (5e-08 and 5e-06). Script also runs sensitivity analyses and creates results table and charts.  


#### AD to protein MR

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/bi-directional-mr/ad_to_protein_mr.R) to perform MR with AD as exposure and selected proteins as the outcomes. Instrumental SNPs for AD selected from Kunkle et al GWAS. Script also runs sensitivity analyses and creates results table and charts. 

