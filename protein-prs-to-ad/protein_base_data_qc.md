#### Outline of steps taken for base data protein QC

- Developed [R script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_base_data_qc_all.R) to identify and implement required QC changes across all proteins.  

- Run R script as a scheduled job on Rosalind high performance computing cluster (HPC) with [bash script](https://github.com/AlexHandy1/ad-genetic-overlap-analysis/blob/master/protein-prs-to-ad/protein_base_data_qc_all.sh).  

- Submit job on HPC in folder with script `/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Scripts` with command `sbatch -p shared --job-name protein-qc protein_base_data_qc_all.sh`.  

- Run `squeue -u <username>` to check job status.  

- Post QC files stored in `/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Post_QC/Final_Shortlist`.  
