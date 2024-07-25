#!/bin/bash/

FOLDER_DERIVS=/path/to/derivatives/
MASK_FOLDER=/path/to/mask/dir/


### Results of the effect of exclusion

for task in cyberball ratemeper ratemepol;
do
	3dClusterize -inset ${FOLDER_DERIVS}/group-level/${task}/${task}_group.nii.gz \
        	-bisided -3.5 3.5 -NN 3 \
        	-ithr 1 \
	        -clust_nvox 24 \
        	-pref_map ${FOLDER_DERIVS}/group-level/${task}/${task}_p001-n24_mask.nii.gz \
       		-mask ${MASK_FOLDER}/group_mask.nii.gz
	
	3dcalc -a ${FOLDER_DERIVS}/group-level/${task}/${task}_group.nii.gz \
		-b${MASK_FOLDER}/group_mask.nii.gz -expr 'a*b' \
		-prefix ${FOLDER_DERIVS}/group-level/${task}/${task}_group_masked.nii.gz

	@chauffeur_afni -ulay ~/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz \
		-box_focus_slices AMASK_FOCUS_OLAY \
		-olay ${FOLDER_DERIVS}/group-level/${task}/${task}_group_masked.nii.gz \
		-cbar Reds_and_Blues_Inv \                                           
		-ulay_range 0% 130% \
		-func_range 5 \
		-set_subbricks -1 1 1 \
		-clusterize "-NN 3 -clust_nvox 24 -mask ${MASK_FOLDER}/group_mask.nii.gz" \
		-thr_olay_p2stat 0.001 \
		-thr_olay_pside bisided \
		-olay_alpha Yes \
		-olay_boxed Yes \
		-opacity 5 \
		-prefix ${FOLDER_DERIVS}/group-level/${task}/results_fig_${task} \
		-set_xhairs OFF \
		-montx 5 -monty 5 \
		-label_mode 1 -label_size 4
		-clusterize_wami AAL3v1

done


#### Results of identity fusion analysis

3dClusterize -inset ${FOLDER_DERIVS}/group-level/ratempol/ratemepol_group.nii.gz \
	-bisided -2.93 2.93 -NN 3 \
	-ithr 9 \
	-clust_nvox 24 \
	-pref_map res-fus_p005-n24_mask.nii.gz \
	-mask ${MASK_FOLDER}/group_mask.nii.gz

3dcalc -a ${FOLDER_DERIVS}/group-level/ratemepol/ratemepol_group.nii.gz \
                -b${MASK_FOLDER}/group_mask.nii.gz -expr 'a*b' \
                -prefix ${FOLDER_DERIVS}/group-level/ratemepol/fusion_group_masked.nii.gz

@chauffeur_afni
	-ulay ~/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz \
	-box_focus_slices AMASK_FOCUS_OLAY \
	-olay ${FOLDER_DERIVS}/group-level/ratemepol/ratemepol_group_masked.nii.gz \
	-cbar Reds_and_Blues_Inv \
	-ulay_range 0% 130% \
	-func_range 5 \
	-set_subbricks -1 9 9 \
	-clusterize "-NN 3 -clust_nvox 24 -mask ${MASK_FOLDER}/group_mask.nii.gz" \
	-thr_olay_p2stat 0.005 \
	-thr_olay_pside bisided \
	-olay_alpha Yes \
	-olay_boxed Yes \
	-opacity 5 \
	-prefix ${FOLDER_DERIVS}/group-level/${task}/results_fig_fusion \
	-set_xhairs OFF \
	-montx 5 -monty 5 \
	-label_mode 1 label_size 4 \
	-clusterize_wami AAL3v1


#### Results of the comparison between different tasks



