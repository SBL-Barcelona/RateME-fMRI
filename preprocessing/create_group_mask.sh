#!/bin/bash

FOLDER=/path/to/main

for task in cyberball ratemeper ratemepol
do
	while read id
	do
		3dAutomask -prefix ${FOLDER}/derivatives/individual-level/${id}/${task}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-mask.nii.gz \
			${FOLDER}/derivatives/individual-level/${id}/${task}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_mean.nii.gz
	done < ${FOLDER}/ids.txt

	3dmask_tool -input ${FOLDER}/derivatives/individual-level/*sub*/${task}/*_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-mask.nii.gz \
		-prefix ${FOLDER}/derivatives/group-level/${task}/group_mask.nii.gz -frac 0.9 -NN3
done
