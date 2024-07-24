FOLDER=/home/luisman/Escritorio/Polex/fMRI/derivatives
while read id;
do
       antsApplyTransforms -i ${FOLDER}/fmriprep/${id}/anat/${id}_space-MNI152NLin2009cAsym_label-GM_probseg.nii.gz -d 3 -o ${FOLDER}/masks/${id}_gm.nii.gz -t ${FOLDER}/fmriprep/${id}/anat/${id}_from-T1w_to-MNI152NLin2009cAsym_mode-image_xfm.h5	
done < ${FOLDER}/../ids.txt; 

fslmerge -t ${FOLDER}/masks/sub* ${FOLDER}/masks/gm_mean.nii.gz;
fslmaths ${FOLDER}/masks/gm_mean.nii.gz -Tmean ${FOLDER}/masks/gm_mean.nii.gz
fslmaths ${FOLDER}/masks/gm_mean.nii.gz -thr 0.2 -bin ${FOLDER}/masks/gm_bin.nii.gz
