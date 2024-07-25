#!/bin/bash
folder=/mnt/neuroimatge/neuroimatge/POLEX

fusion=($(cat ${folder}/covariates/fusion_dych.csv))
narciss=($(cat ${folder}/covariates/colNarcissMean.csv))

for task in cyberball ratemeper ratemepol
do
	analysis_out=${folder}/derivatives/group-level/${task}/${task}
	mkdir -p ${folder}/derivatives/group-level/${task}
	fout=${folder}/scripts/group-level_${task}.sh

	fd=($(cat ${folder}/outputFiles/fd_${task}_cent.csv))
        age=($(cat ${folder}/outputFiles/age_cent.csv))
        gender=($(cat ${folder}/outputFiles/gender.csv))

	if [[ ${task} == "ratemepol" ]]
        then
		echo -e "subj\tfd\tage\tgender\tfusion" > ${folder}/derivatives/group-level/${task}/covariates.txt
	else
		echo -e "subj\tfd\tage\tgender" > ${folder}/derivatives/group-level/${task}/covariates.txt
	fi

	echo -e "3dMEMA -prefix ${analysis_out}_group -jobs 12 \\" > ${fout}
	echo -e "\t-set exclusion-inclusion \\" >> ${fout}
	
	i=0

	while read id
	do
		echo -e "\t\t${id} ${folder}/derivatives/individual-level/${id}/${task}/Decon_REML_block_cont+tlrc'[GLTsym01#0_Coef]' ${folder}/derivatives/individual-level/${id}/${task}/Decon_REML_block_cont+tlrc'[GLTsym01#0_Tstat]' \\" >> ${fout}
		if [[ ${task} == "ratemepol" ]]
		then
			printf "%s\t%s\t%s\t%s\t%s\n" "$(echo -e "${id}")" "${fd[${i}]}" "${age[${i}]}" "${gender[${i}]}" "${fusion[${i}]}"  >> ${folder}/derivatives/group-level/${task}/covariates.txt
		else
			printf "%s\t%s\t%s\t%s\t%s\n" "$(echo -e "${id}\t")" "${fd[${i}]}" "${age[${i}]}" "${gender[${i}]}" >> ${folder}/derivatives/group-level/${task}/covariates.txt
		fi
		i=$(expr ${i} + 1)
	done < ${folder}/ids.txt
	
	echo -e "\t-missing_data 0 \\" >> ${fout}
	echo -e "\t-covariates ${folder}/derivatives/group-level/${task}/covariates.txt -residual_Z -max_zeros 0.1" >> ${fout}

done

