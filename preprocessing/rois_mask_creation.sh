#!/bin/bash

#### Script to transform the functional coactivation atlas downloaded from https://neurovault.org/images/395092/ into functional images space. Then, this script creates a nifti file for each region.

FOLDER=/path/to/files/dir

3dNwarpApply -prefix ${FOLDER}/derivatives/masks/k50_2mm_MNI2009Asym-fMRI.nii.gz \
	-source ${FOLDER}/derivatives/masks/k50_2mm.nii.gz -interp NN \
	-nwarp "${FOLDER}/derivatives/masks/anatQQ.MNINL6_WARP.nii ${FOLDER}/derivatives/masks/anatQQ.MNINL6.aff12.1D" \
	-master ${FOLDER}/derivatives/group-level/ratemepol/group_mask.nii.gz


indices=($(3dROIstats -quiet -mask ${FOLDER}/derivatives/masks/k50_2mm_MNI2009Asym-fMRI.nii.gz ${FOLDER}/derivatives/masks/k50_2mm_MNI2009Asym-fMRI.nii.gz  | tr '\t' '\n' | awk '{print int($0)}'))

for i in $(seq 1 ${#indices[@]})
do
        fslmaths ${FOLDER}/derivatives/masks/k50_2mm_MNI2009Asym-fMRI.nii.gz -uthr ${indices[${i}]} -thr ${indices[${i}]} -bin ${FOLDER}/derivatives/masks/k50_2mm_MNI2009Asym-fMRI_roi-${i}.nii.gz

done

