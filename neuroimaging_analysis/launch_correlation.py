#!/bin/bash

folder_individual=/mnt/neuroimatge/neuroimatge/POLEX/derivatives/firstlevel
folder_out=/mnt/neuroimatge/neuroimatge/POLEX/derivatives/roi_correlation
roifile=/mnt/neuroimatge/neuroimatge/POLEX/derivatives/atlas/whole-mask/k50_2mm_MNI2009Asym-fMRI-masked_roi-
ids=/mnt/neuroimatge/neuroimatge/POLEX/ids.txt
score_file=/mnt/neuroimatge/neuroimatge/POLEX/covariates/spirForm_sp.csv

python -c "from mvpa import roi_correlation; roi_correlation('${folder_individual}', '${ids}', '${roifile}', '2 5 21 25 29', '${score_file}', '${folder_out}')"
