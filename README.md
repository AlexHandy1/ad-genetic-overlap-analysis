Background and Objectives
-------

* Proteins present in blood plasma have been associated with Alzheimer's Disease (AD) and offer accessible sources for disease modification and prediction.   

* However, the genetic overlap between blood plasma proteins and AD remains unknown.   

* The primary research objective is to identify if there are significant associations between blood plasma protein polygenic risk scores (PRS) and AD.  

* For blood plasma protein PRS that do show significant association with AD, the secondary objective is to identify whether exposure to the protein is causal using Mendelian Randomization (MR).  


Analysis Structure
-------

#### The analysis is structured around 4 main steps  

1. **Protein Shortlist** - Identify a shortlist of blood plasma proteins from existing literature that have been associated with AD or AD phenotypes  [(select-protein-shortlist)](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/tree/master/select-protein-shortlist)  

2. **Protein PRS to AD** - Create PRS models for shortlist of proteins and test their association with AD in three cohorts [(protein-prs-to-ad)](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/tree/master/protein-prs-to-ad)  

3. **AD PRS to protein** - Create an AD PRS model and test bi-directional association with individual blood plasma protein levels in separate cohort[(ad-prs-to-protein)](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/tree/master/ad-prs-to-protein)   

4. **Bi-directional MR** - Test for causality by conducting two sample, bi-directional MR on blood plasma proteins that are nominally significant in one or both PRS analyses  [(bi-directional-mr)](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/tree/master/bi-directional-mr) 


#### Considerations

* The folders within this repository contain the analysis scripts that form the analysis pipeline. This is focused primarily around steps 2-4 as step 1 is currently a largely manual process.   

* The analysis is designed to run primarily on King's College London's high performance computing cluster [Rosalind](https://rosalind.kcl.ac.uk) where input data can be held securely.   

* Currently, the scripts do not operate as an end-to-end pipeline and have been designed for personal efficiency rather than third party replication.  

* The analysis is ongoing and the corresponding scripts continue to be updated.  Each repository may not contain the comprehensive set of scripts used to complete the analysis.  


Planned Improvements
-------

Once my MSc thesis has been submitted, I am planning two types of improvements, updates to the existing analysis pipeline and extensions to the research scope.  

Below is a list in order of priority:   

* Conduct Bayesian co-localisation on SNP signals within significant proteins  

* Build multi-protein PRS prediction panel using machine learning  

* Remove a-priori protein filter and extend analysis to longer list of proteins (n > 100)  

* Build automated, reproducible analysis pipeline with integrated tests on public cloud service   

