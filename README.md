Background and Objectives
-------

* Blood plasma proteins have been associated with Alzheimer’s disease (AD), but understanding which proteins are on the causal pathway remains challenging.     

* This study aims to investigate the genetic overlap between candidate proteins and AD using polygenic risk scores (PRS) and interrogate their causal relationship using bi-directional Mendelian Randomization (MR).   

* More details are available in the academic paper [('Assessing genetic overlap and causality between blood plasma proteins and Alzheimer’s Disease')](https://www.medrxiv.org/content/10.1101/2021.04.21.21255751v1)


Analysis Structure
-------

#### The analysis is structured around 4 main steps  

1. **Protein Shortlist** - Identify a shortlist of blood plasma proteins from existing literature that have been associated with AD or AD phenotypes.  [(select-protein-shortlist)](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/tree/master/select-protein-shortlist) 

2. **Protein PRS to AD** - Create PRS models for shortlist of proteins and test their association with AD using logistic regression in three cohorts. [(protein-prs-to-ad)](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/tree/master/protein-prs-to-ad)  

3. **AD PRS to protein** - Create an AD PRS model and test bi-directional association with individual blood plasma protein levels using linear regression in separate cohort. [(ad-prs-to-protein)](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/tree/master/ad-prs-to-protein)   

4. **Bi-directional MR** - Test for causality by conducting two sample, bi-directional MR on blood plasma proteins that are significant in one or both PRS analyses.  [(bi-directional-mr)](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/tree/master/bi-directional-mr) 


#### Considerations

* The folders within this repository contain the analysis scripts that form the analysis pipeline. This is focused primarily around steps 2-4 as step 1 is currently a largely manual process.   

* The analysis is designed to run primarily on King's College London's high performance computing cluster [Rosalind](https://rosalind.kcl.ac.uk) where input data can be held securely.   

* Currently, the scripts do not operate as an end-to-end pipeline and have been designed for personal efficiency rather than third party replication.  

