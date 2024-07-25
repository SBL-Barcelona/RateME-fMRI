#!/bin/bash
FOLDER=/mnt/neuroimatge/neuroimatge/POLEX

while read id
do
	for task in cyberball ratemeper ratemepol
	do	
		FMRI_FOLDER=${FOLDER}/derivatives/fmriprep/${id}/func
		OUT_FOLDER=${FOLDER}/derivatives/individual-level/${id}/${task}

		mkdir -p ${OUT_FOLDER}


		if ! [[ -f ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_bold-scaled.nii.gz ]]
		then		

			### Smoothing
			
			3dmerge -1blur_fwhm 6.0 -doall -prefix ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_bold.nii.gz \
				${FMRI_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz	
		

			### Rescaling to afni standard (mean of each voxel's timeseries of 100 and signal is percentage)
	
			3dTstat -prefix ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_mean.nii.gz \
				${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_bold.nii.gz

			 3dcalc -a ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_mean.nii.gz \
	                        -b ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_bold.nii.gz \
	                        -expr 'min(200, b/a*100)*step(a)*step(b)' \
	                        -prefix ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_bold-scaled.nii.gz
		fi


		### Convert censor file into afni 1D format
		1d_tool.py -infile ${OUT_FOLDER}/censor_${task}.csv -write ${OUT_FOLDER}/censor_${task}.1D


		### Prepare the linear model and execute it

		if [[ ${task} == "cyberball" ]]
		then
			3dDeconvolve -force_TR 1.75 \
				-input ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_bold-scaled.nii.gz \
				-polort 4 -num_stimts 4 \
				-stim_times 1 ${OUT_FOLDER}/inclusion_cyberball.csv 'BLOCK(30,1)' -stim_label 1 INCLUSION \
				-stim_times 2 ${OUT_FOLDER}/exclusion_cyberball.csv 'BLOCK(30,1)' -stim_label 2 EXCLUSION \
				-stim_times 3 ${OUT_FOLDER}/mood_cyberball.csv 'BLOCK(4,1)' -stim_label 3 MOOD \
				-stim_times 4 ${OUT_FOLDER}/keypress_cyberball.csv 'BLOCK(1,1)' -stim_label 4 KEY \
				-ortvec ${OUT_FOLDER}/confounds_cyberball.csv NOISE -xjpeg ${OUT_FOLDER}/design.png \
				-x1D ${OUT_FOLDER}/design.1D -x1D_stop -censor ${OUT_FOLDER}/censor_${task}.1D
		else
			3dDeconvolve -force_TR 1.75 \
				-input ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_bold-scaled.nii.gz \
				-polort 4 -num_stimts 3 \
                        	-stim_times 1 ${OUT_FOLDER}/inclusion_${task}.csv 'BLOCK(30,1)' -stim_label 1 INCLUSION \
                        	-stim_times 2 ${OUT_FOLDER}/exclusion_${task}.csv 'BLOCK(30,1)' -stim_label 2 EXCLUSION \
                        	-stim_times 3 ${OUT_FOLDER}/mood_${task}.csv 'BLOCK(4,1)' -stim_label 3 MOOD \
                        	-ortvec ${OUT_FOLDER}/confounds_${task}.csv NOISE -xjpeg ${OUT_FOLDER}/design.png \
                        	-x1D ${OUT_FOLDER}/design.1D -x1D_stop -censor ${OUT_FOLDER}/censor_${task}.1D
		fi


		3dREMLfit -matrix ${OUT_FOLDER}/design.1D -input ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_desc-preproc-smooth_bold-scaled.nii.gz \
			-gltsym 'SYM: EXCLUSION -INCLUSION' -Rbuck ${OUT_FOLDER}/Decon_REML_block \
			-Rvar ${OUT_FOLDER}/Decon_REML_block_var -Rglt ${OUT_FOLDER}/Decon_REML_block_cont \
			-tout -Rerrts ${OUT_FOLDER}/Decon_REML_block_res -Rwherr ${OUT_FOLDER}/Decon_REML_block_wres
		
		3dTcat -prefix ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_individual-level-res.nii.gz ${OUT_FOLDER}/Decon_REML_block_res+tlrc
		3dTcat -prefix ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_individual-level-cont.nii.gz ${OUT_FOLDER}/Decon_REML_block_cont+tlrc
		3dTcat -prefix ${OUT_FOLDER}/${id}_task-${task}_space-MNI152NLin2009cAsym_individual-level.nii.gz ${OUT_FOLDER}/Decon_REML_block+tlrc
	done
done < ${FOLDER}/ids.txt
