#### Outline of steps taken for protein genetic correlation analysis  

- Download [ldsc package](https://github.com/bulik/ldsc) and accompanying european ldscore data (refer to package README).  

- Activate conda environment on HPC by loading module `devtools/anaconda/2019.3-python2.7.16` and creating ldsc environment `conda env create --file environment.yml`. Must have access to environment.yml file.  

- If not already completed for heritability analysis, run [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_heritability_analysis_setup.sh) to run munge_sumstats.py and create a .sumstats file for each post QC protein. On HPC use `sbatch -p shared --job-name h2-setup protein_heritability_analysis_setup.sh` and unzip .gz sumstat files in sumstats folder `gunzip *.gz`.     

- Create list of .sumstat files in list format required for rg analysis :  
	- `sed 's/.*/"&.sumstats"/' protein_shortlist.txt > protein_shortlist_sumstats.txt`.  
	- `paste -s -d " " protein_shortlist_sumstats.txt > protein_shortlist_sumstats_one_line.txt`

- Run genetic correlation analysis [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_genetic_correlation_analysis.sh) to run ldsc.py on each post QC protein sumstats file and calculate rg. On HPC use `sbatch -p shared --job-name rg-run protein_genetic_correlation_analysis.sh`.  

- Run [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/prepare_genetic_correlation_analysis_results.R) to prepare a CSV file of summary results for all proteins.   