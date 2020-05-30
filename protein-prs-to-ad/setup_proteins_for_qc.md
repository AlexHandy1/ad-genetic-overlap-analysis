#### List of protein SomaLogic codes for 31 proteins on shortlist for QC  

PPY.4588.1.2  
APOE.2937.10.2  
CFH.4159.130.1  
SERPING1.4479.14.2  
C3.2755.8.2  
FGA.FGB.FGG.4907.56.1  
APCS.2474.54.5  
HP.3054.3.2  
IL3.4717.55.2  
C4A.C4B.4481.34.2  
IL10.2773.50.2  
VTN.13125.45.3  
IGFBP2.2570.72.5  
ANGPT2.13660.76.3  
APOB.2797.56.2  
CCL26.9168.31.3  
CRP.4337.49.2  
CLU.4542.24.2  
CSF3.8952.65.3  
IL13.3072.4.2  
CXCL8.3447.64.2  
KITLG.9377.25.3  
MMP9.2579.17.5  
NPPB.3723.1.2  
PLG.3710.49.2  
RETN.3046.31.1  
TF.4162.54.2  
TNC.4155.3.2  
TNF.5936.53.3  
VCAM1.2967.8.1  
GC.6581.50.3  

#### Outline of steps taken to setup shortlist proteins for QC

- Locate Sun et al files in `/mnt/lustre/groups/proitsi/COLOC/MOLOC/datasets/SOMALOGIC_SUN`. Stored in .gz format.    

- Create protein_shortlist.txt file for SomaLogic codes.    

- Create new folder in personal working directory for pre QC proteins - `/mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Pre_QC/Final_Shortlist`

- Add ".gz," to end of each protein with `sed 's/.*/&.gz,/' protein_shortlist.txt > protein_shortlist_gz.txt` and manually remove "," after last protein.  

- Copy across ".gz" files from original folder to new pre QC folder `cp {PPY.4588.1.2.gz,APOE.2937.10.2.gz,CFH.4159.130.1.gz,SERPING1.4479.14.2.gz,C3.2755.8.2.gz,FGA.FGB.FGG.4907.56.1.gz,APCS.2474.54.5.gz,HP.3054.3.2.gz,IL3.4717.55.2.gz,C4A.C4B.4481.34.2.gz,IL10.2773.50.2.gz,VTN.13125.45.3.gz,IGFBP2.2570.72.5.gz,ANGPT2.13660.76.3.gz,APOB.2797.56.2.gz,CCL26.9168.31.3.gz,CRP.4337.49.2.gz,CLU.4542.24.2.gz,CSF3.8952.65.3.gz,IL13.3072.4.2.gz,CXCL8.3447.64.2.gz,KITLG.9377.25.3.gz,MMP9.2579.17.5.gz,NPPB.3723.1.2.gz,PLG.3710.49.2.gz,RETN.3046.31.1.gz,TF.4162.54.2.gz,TNC.4155.3.2.gz,TNF.5936.53.3.gz,VCAM1.2967.8.1.gz,GC.6581.50.3.gz} /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Pre_QC/Final_Shortlist` .  

- Gunzip all files in new pre QC folder - `gunzip *.gz`.  

- Check the number of files in folder - `ls | wc -l` = 31.  

- Check the number of lines in each file = 10,572,810
	`#!/bin/bash
	 for file in /mnt/lustre/groups/proitsi/Alex/Protein_PRS_to_AD/Base_Data/Pre_QC/Final_Shortlist/*; do 
		wc -l $file
	 done
	`.  




