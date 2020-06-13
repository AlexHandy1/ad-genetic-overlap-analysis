### Overview of analysis pipeline for AD PRS to protein  

#### QC for AD base data

- Download Kunkle et al AD data from [NIAGADS](https://www.niagads.org/datasets/ng00075) and upload to Rosalind HPC.  

- Developed [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/ad-prs-to-protein/ad_base_data_qc.R) to identify and implement required QC changes. Run on HPC.  

- Post QC files stored in `/mnt/lustre/groups/proitsi/Alex/AD_PRS_to_AD/Base_Data/Post_QC/`.  


#### QC for target protein data

- Align genetic QC with QC procedures applied to all participant GERAD, ADNI and ANM data with PLINK - ` plink --bfile three_batches_imputed.pQTL.QC --autosome --geno 0.02 --hwe 0.00001 --maf 0.01 --make-bed --mind 0.03 --noweb --out ANM_3B_WITH_APOE `.  

- Create stratified subsets (no APOE, gender, age) for analysis with PLINK (example command for no APOE) - `plink --bfile ANM_3B_WITH_APOE --exclude Overlapping_APOESNPs.txt --make-bed --noweb --out ANM_3B_NO_APOE `.  

- Create anm_protein_shortlist_names.txt file for names used in anm phenotype file. Had to conduct a manual mapping in excel for shortlist because names in index files provided did not match so could not be directly linked to UniProt IDs.  
	- used `sed 's/.*/"&",/'` to add quotations and comma at end of line and  `paste -s -d " "` to compress to one line.  

#### AD PRS analysis

- Run PRSice command with [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/ad-prs-to-protein/protein_prs_all_with_apoe.sh) to analyse **all groups with and without** APOE SNPs included - `sbatch -p shared --job-name ad-prs ad_prs_all_groups.sh`.  

- Prepare results with [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/ad-prs-to-protein/prepare_ad_pres_results_adj_p.R) and download csvs for use in Shiny app.  
 




