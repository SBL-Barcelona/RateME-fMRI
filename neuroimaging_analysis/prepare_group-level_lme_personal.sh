folder=/mnt/neuroimatge/neuroimatge/POLEX
fusion=($(cat ${folder}/covariates/fusion_text.csv))
analysis_out=${folder}/derivatives/group-level/lme/group-level_personal
age=($(cat ${folder}/covariates/age_cent.csv))
gender=($(cat ${folder}/covariates/gender_text.csv))
fd=($(cat ${folder}/covariates/fd_alltask_cent.csv))

mkdir -p ${analysis_out}

j=0

echo -e "Subj\tFD\tTask\tFusion\tGender\tAge\tInputFile" > ${analysis_out}/Table_personal.txt

fout=${folder}/Scripts/group-level_lme-personal.sh
echo -e "cd ${analysis_out} " > ${fout}
echo -e "3dLMEr -prefix ${analysis_out}/Results_personal -jobs 12 \\" >> ${fout}

echo -e "\t-model 'FD+Task+Age+Gender+(1|Subj)' -qVars 'Age,FD' \\" >> ${fout}
echo -e "\t-bounds -2 2 -SS_type 3 \\" >> ${fout}

echo -e "\t-gltCode persdiscrim 'Task : 1*ratemeper ' \\" >> ${fout}
echo -e "\t-gltCode ostracism 'Task : 1*cyberball' \\" >> ${fout}
echo -e "\t-gltCode taskdiff 'Task : 1*cyberball -1*ratemeper' \\" >> ${fout}
echo -e "\t-dataTable @Table_personal.txt" >> ${fout}

for task in cyberball ratemeper
do

	i=0
	while read id
	do
		
		printf "%s\t%s\t%s\t%s\t%s\t%s\n" "$(echo -e "${id}")" "$(echo ${fd[${j}]})" "$(echo ${task})" \
			"$(echo ${gender[${i}]})" "$(echo ${age[${i}]})" "../../../individual-level/${id}/${task}/Decon_REML_block+tlrc[7]" >> ${analysis_out}/Table_personal.txt

		i=$(expr ${i} + 1)
		j=$(expr ${j} + 1)

	done < ${folder}/ids.txt

done
