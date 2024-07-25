FOLDER=/mnt/neuroimatge/neuroimatge/POLEX

for task in cyberball ratemeper ratemepol
do
	while read id
	do
		3dAutomask -prefix ${FOLDER}/derivatives/firstlevel/${id}/${task}/afni/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-mask.nii.gz \
			${FOLDER}/derivatives/firstlevel/${id}/${task}/afni/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_mean.nii.gz
	done < ../ids.txt

	3dmask_tool -input ${FOLDER}/derivatives/firstlevel/*sub*/${task}/afni/*_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-mask.nii.gz \
		-prefix ${FOLDER}/derivatives/secondlevel/${task}/group_mask.nii.gz -frac 0.9 -NN3
done
