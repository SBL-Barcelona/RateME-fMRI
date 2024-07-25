#!/bin/bash

### This script computes the correlation of the mean effect of exclusion vs inclusion in the ROIs obtained form identity fusion analysis (p<0.005 k=24) with th intergroup attitudes scales. To run it, the path to main folder is needed and score_file must be changed for each of the variables. 

folder=/path/to/main

folder_individual=${folder}/derivatives/firstlevel
folder_out=${folder}/derivatives/roi_correlation
roifile=${folder}/derivatives/atlas/whole-mask/k50_2mm_MNI2009Asym-fMRI-masked_roi-
ids=${folder}/ids.txt
score_file=${folder}/covariates/spirForm_sp.csv

python -c "from mvpa import roi_correlation; roi_correlation('${folder_individual}', '${ids}', '${roifile}', '2 5 21 25 29', '${score_file}', '${folder_out}')"
