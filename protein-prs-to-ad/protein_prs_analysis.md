#### Outline of steps taken for protein PRS analysis

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

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_prs_all_meta_analysis.R) on **all participants** prepped meta-analysis data and output results. Update input and output folder in script for with and without APOE and re-run.   

- Run [R script - **To-do**](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_prs_stratified_meta_analysis.R) on **participants grouped by gender and age brackets** prepped meta-analysis data and output results. Update input and output folder in script for with and without APOE and re-run.   






