### Overview of analysis pipeline for protein PRS to AD

#### Protein QC for base data

- Developed [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_base_data_qc_all.R) to identify and implement required QC changes across all proteins.  

- Run R script as a scheduled job on Rosalind high performance computing cluster (HPC) with [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_base_data_qc_all.sh).  

- Submit job on HPC in folder with script `/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Scripts` with command `sbatch -p shared --job-name protein-qc protein_base_data_qc_all.sh`.  

- Run `squeue -u <username>` to check job status.  

- Post QC files stored in `/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Post_QC/Final_Shortlist`. 


#### Protein heritability analysis

- Download [ldsc package](https://github.com/bulik/ldsc) and accompanying european ldscore data (refer to package README).  

- Activate conda environment on HPC by loading module `devtools/anaconda/2019.3-python2.7.16` and creating ldsc environment `conda env create --file environment.yml`. Must have access to environment.yml file.  

- Run heritability analysis setup [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_heritability_analysis_setup.sh) to run munge_sumstats.py and create a .sumstats file for each post QC protein. On HPC use `sbatch -p shared --job-name h2-setup protein_heritability_analysis_setup.sh` and unzip .gz sumstat files in sumstats folder `gunzip *.gz`.     

- Run heritability analysis [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_heritability_analysis.sh) to run ldsc.py on each post QC protein sumstats file and calculate h2. On HPC use `sbatch -p shared --job-name h2-run protein_heritability_analysis.sh`.  

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/prepare_heritability_analysis_results.R) to prepare a CSV file of summary results for all proteins.  


#### Protein genetic correlation analysis  

- Download [ldsc package](https://github.com/bulik/ldsc) and accompanying european ldscore data (refer to package README).  

- Activate conda environment on HPC by loading module `devtools/anaconda/2019.3-python2.7.16` and creating ldsc environment `conda env create --file environment.yml`. Must have access to environment.yml file.  

- If not already completed for heritability analysis, run [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_heritability_analysis_setup.sh) to run munge_sumstats.py and create a .sumstats file for each post QC protein. On HPC use `sbatch -p shared --job-name h2-setup protein_heritability_analysis_setup.sh` and unzip .gz sumstat files in sumstats folder `gunzip *.gz`.     

- Create list of .sumstat files in list format required for rg analysis :  
	- `sed 's/.*/"&.sumstats"/' protein_shortlist.txt > protein_shortlist_sumstats.txt`.  
	- `paste -s -d " " protein_shortlist_sumstats.txt > protein_shortlist_sumstats_one_line.txt`

- Run genetic correlation analysis [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_genetic_correlation_analysis.sh) to run ldsc.py on each post QC protein sumstats file and calculate rg. On HPC use `sbatch -p shared --job-name rg-run protein_genetic_correlation_analysis.sh`.  

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/prepare_genetic_correlation_analysis_results.R) to prepare a CSV file of summary results for all proteins.   


#### Protein PRS analysis

##### Run Individual Sample PRS Analysis  

- Installed latest version of PRSice (v2.3.1e) on HPC, following CMake instructions on [github page](https://github.com/choishingwan/PRSice).  

- Run PRSice command with [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_prs_all_with_apoe.sh) to analyse **all participants** individually in GERAD, ADNI and ANM **with** APOE SNPs included - `sbatch -p shared --job-name prot-prs-all-with-ap protein_prs_all_with_apoe.sh`.  

- Run PRSice command with [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_prs_all_no_apoe.sh) to analyse **all participants** individually in GERAD, ADNI and ANM **without** APOE SNPs included - `sbatch -p shared --job-name prot-prs-all-no-ap protein_prs_all_no_apoe.sh`.   

- Run PRSice command with [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_prs_stratified_with_apoe.sh) to analyse **participants grouped by gender and age brackets** individually in GERAD, ADNI and ANM **with** APOE SNPs included - `sbatch -p shared --job-name prot-prs-groups-with-ap protein_prs_stratified_with_apoe.sh`.  

- Run PRSice command with [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_prs_stratified_no_apoe.sh) to analyse **participants grouped by gender and age brackets** individually in GERAD, ADNI and ANM **without** APOE SNPs included - `sbatch -p shared --job-name prot-prs-groups-no-ap protein_prs_stratified_no_apoe.sh`.  

##### Prepare Individual Sample Results  

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/prepare_prs_all_results.R) on output files for **all participants** analysis to prepare individual sample results. Update input and output folder in script for with and without APOE and re-run.  

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/prepare_prs_stratified_results.R) on output files for **participants grouped by gender and age brackets** to prepare individual sample results. Update input and output folder in script for with and without APOE and re-run.    

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/prepare_prs_all_metaanalysis.R) on **all participants** individual sample results to prepare data for meta-analysis. Update input and output folder in script for with and without APOE and re-run.   

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/prepare_prs_stratified_metaanalysis.R) on **participants grouped by gender and age brackets** individual sample results to prepare data for meta-analysis, runs for both APOE status (update).    


##### Run Meta-Analysis

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_prs_all_meta_analysis.R) on **all participants** data that has been prepped for random-effects meta-analysis with REML and output results. Update input and output folder in script for with and without APOE and re-run.   

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_prs_stratified_meta_analysis.R) on **participants grouped by gender and age brackets** data that has been prepped for random-effects meta-analysis with REML and output results, runs for both APOE status (update).   
