#!/bin/bash

FOLDER=/home/luisman/Escritorio/Polex/fMRI/derivatives

#fslmaths ${FOLDER}/masks/self-reference/self-ref_ALE.nii.gz -bin \
#	${FOLDER}/masks/self-reference/self-ref_brain.nii.gz

#flirt -in ${FOLDER}/masks/self-reference/self-ref_brain.nii.gz \
#	-ref /home/luisman/fsl/data/standard/MNI152_T1_2mm_brain_mask.nii.gz \
#	-omat ${FOLDER}/masks/self-reference/self-ref_to_MNI6Asym.mat

#fslmaths ${FOLDER}/masks/self-reference/self-ref_P.nii.gz -uthr 0.001 \
#	-bin ${FOLDER}/masks/self-reference/self-ref_mask.nii.gz

#ResampleImage 3 ${FOLDER}/masks/self-reference/self-ref_mask.nii.gz \
#        ${FOLDER}/masks/self-reference/self-ref_mask_MNI6Asym.nii.gz 91x109x91 1

#flirt -in ${FOLDER}/masks/self-reference/self-ref_mask.nii.gz \
#	-ref /home/luisman/fsl/data/standard/MNI152_T1_2mm_brain_mask.nii.gz \
#	-out ${FOLDER}/masks/self-reference/self-ref_mask_MNI6Asym.nii.gz -applyxfm \
#	-init ${FOLDER}/masks/self-reference/map_to_MNI6Asym.mat -interp nearestneighbour


3dClusterize -inset ${FOLDER}/masks/social-pain/SP_ALE_thr.nii.gz -1sided 'RIGHT_TAIL' 0.15 -NN 3 -ithr 0 -clust_nvox 20 -pref_map ${FOLDER}/masks/social-pain/SP_ALE_thr015-n20.nii.gz

3dcalc -a ${FOLDER}/masks/social-pain/SP_ALE_thr015-n20.nii.gz -expr 'step(a)' -prefix ${FOLDER}/masks/social-pain/SP_ALE_thr015-n20_mask.nii.gz

python3 -c "import filter_atlas; filter_atlas.filter_atlas('${FOLDER}/masks/atlas/k50_2mm.nii.gz', '${FOLDER}/masks/social-pain/SP_ALE_thr015-n20_mask.nii.gz')"

3dNwarpApply -prefix ${FOLDER}/masks/atlas/social-pain_mask_clust20_k50_2mm_MNI2009Asym-fMRI.nii.gz \
	-source ${FOLDER}/masks/atlas/SP_ALE_thr015-n20_mask_k50_2mm.nii.gz -interp NN \
	-nwarp "${FOLDER}/masks/transforms/anatQQ.MNINL6_WARP.nii ${FOLDER}/masks/transforms/anatQQ.MNINL6.aff12.1D" \
	-master ${FOLDER}/secondlevel/ratemeper/magnitude/group_mask.nii.gz

#fslmaths ${FOLDER}/masks/atlas/exclusion_mask_clust20_k50_2mm_MNI2009Asym-fMRI.nii.gz -mas ${FOLDER}/secondlevel/ratemeper/magnitude/group_mask.nii.gz ${FOLDER}/masks/atlas/exclusion_mask_clust20_k50_2mm_MNI2009Asym-fMRI-masked.nii.gz

