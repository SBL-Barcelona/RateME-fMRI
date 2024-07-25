#!/bin/bash

#### Script to transform the Social Pain atlas dwonloaded from


FOLDER=/path/to/files/dir

3dClusterize -inset ${FOLDER}/SP_ALE_thr.nii.gz -1sided 'RIGHT_TAIL' 0.15 -NN 3 -ithr 0 -clust_nvox 20 -pref_map ${FOLDER}/SP_ALE_thr015-n20.nii.gz
3dcalc -a ${FOLDER}/SP_ALE_thr015-n20.nii.gz -expr 'step(a)' -prefix ${FOLDER}/SP_ALE_thr015-n20_mask.nii.gz

python3 -c "import filter_atlas; filter_atlas.filter_atlas('${FOLDER}/k50_2mm.nii.gz', '${FOLDER}/SP_ALE_thr015-n20_mask.nii.gz')"

3dNwarpApply -prefix ${FOLDER}/social-pain_mask_clust20_k50_2mm_MNI2009Asym-fMRI.nii.gz \
	-source ${FOLDER}SP_ALE_thr015-n20_mask_k50_2mm.nii.gz -interp NN \
	-nwarp "${FOLDER}anatQQ.MNINL6_WARP.nii ${FOLDER}anatQQ.MNINL6.aff12.1D" \
	-master ${FOLDER}/group_mask.nii.gz


indices=($(3dROIstats -quiet -mask ${FOLDER}/social-pain_mask_clust20_k50_2mm_MNI2009Asym-fMRI.nii.gz ${FOLDER}/social-pain_mask_clust20_k50_2mm_MNI2009Asym-fMRI.nii.gz  | tr '\t' '\n' | awk '{print int($0)}'))

for i in $(seq 1 ${#indices[@]})
do
        fslmaths ${FOLDER}/social-pain_mask_clust20_k50_2mm_MNI2009Asym-fMRI.nii.gz -uthr ${indices[${i}]} -thr ${indices[${i}]} -bin ${FOLDER}/social-pain_mask_clust20_k50_2mm_MNI2009Asym-fMRI_roi-${i}.nii.gz

done

