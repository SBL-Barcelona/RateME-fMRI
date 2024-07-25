folder=/mnt/neuroimatge/neuroimatge/POLEX
fusion=($(cat ${folder}/covariates/fusion_text.csv))
analysis_out=${folder}/derivatives/group-level/lme/group-level_discrimination
age=($(cat ${folder}/covariates/age_cent.csv))
gender=($(cat ${folder}/covariates/gender_text.csv))
fd=($(cat ${folder}/covariates/fd_alltask_cent.csv))

mkdir -p ${analysis_out}

j=56

echo -e "Subj\tFD\tTask\tFusion\tGender\tAge\tInputFile" > ${analysis_out}/Table_discrimination.txt

fout=${folder}/Scripts/group_3dlme_discrimination.sh
echo -e "cd ${analysis_out} " > ${fout}
echo -e "3dLMEr -prefix ${analysis_out}/Results_discrimination -jobs 12 \\" >> ${fout}

echo -e "\t-model 'FD+Task*Fusion+Age+Gender+(1|Subj)' -qVars 'Age,FD' \\" >> ${fout}
echo -e "\t-bounds -2 2 -SS_type 3 \\" >> ${fout}

echo -e "\t-gltCode persdiscrim 'Task : 1*ratemeper ' \\" >> ${fout}
echo -e "\t-gltCode groupdiscrim 'Task : 1*ratemepol' \\" >> ${fout}
echo -e "\t-gltCode taskdiff 'Task : 1*ratemeper -1*ratemepol' \\" >> ${fout}
echo -e "\t-gltCode fusion 'Task : 1*ratemepol Fusion : 1*fused -1*nonfused' \\" >> ${fout}
echo -e "\t-dataTable @Table_discrimination.txt" >> ${fout}

for task in ratemeper ratemepol
do

	i=0
	while read id
	do

		printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$(echo -e "${id}")" "$(echo ${fd[${j}]})" "$(echo ${task})" "$(echo ${fusion[${i}]})" \
			"$(echo ${gender[${i}]})" "$(echo ${age[${i}]})" "../../../individual-level/${id}/${task}/Decon_REML_block+tlrc[7]" >> ${analysis_out}/Table_discrimination.txt

		i=$(expr ${i} + 1)
		j=$(expr ${j} + 1)

	done < ${folder}/ids.txt

done
