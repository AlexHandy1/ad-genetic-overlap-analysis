Background and Objectives
-------

* Proteins present in blood plasma are modifiable and have been associated with AD but understanding which proteins are causal remains challenging.     

* Recent advances in proteomics enable analysis of the genetic overlap of blood plasma proteins and AD and combined with Mendelian Randomization (MR) can help determine protein causality.   

* This project aims to identify if there are significant associations between blood plasma protein polygenic risk scores (PRS) and AD and, for associated proteins, identify whether exposure to the protein is causal using MR.   


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

* The analysis is ongoing and the corresponding scripts continue to be updated.  Each repository may not contain the comprehensive set of scripts used to complete the analysis.  


Planned Improvements
-------

Once my MSc thesis has been submitted, I am planning two types of improvements, updates to the existing analysis pipeline and extensions to the research scope.  

Below is a list in order of priority:   

* Build multi-protein PRS prediction panel using machine learning

* Build automated, reproducible analysis pipeline with integrated tests on public cloud service   

