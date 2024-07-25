import numpy as np
from scipy import io
import os
import nibabel as nib
import pandas as pd
from nilearn.maskers import NiftiMasker
from statsmodels.regression.linear_model import OLS


def roi_correlation(folder_individual, ids_file, roiFile, rois, score_file, folder_out):

    file = open(ids_file, 'r')
    ids = list(file.read().splitlines())
    rois = rois.split()
    nrois = len(rois)
    roifiles = [nib.load(roiFile+str(i)+'.nii.gz') for i in rois]

    X = load_covariates(score_file)

    imgs = []
    tags = []
    groups = []
    print('Reading subjects data')
    for id in ids:
        img = nib.load(os.path.join(folder_individual,id,'ratemepol/afni',id+'_task-ratemepol_space-MNI152NLin2009cAsym_firstlevel.nii.gz'))
        imgs.append(index_img(img, 7))
        tags.append('ratemepol')

    i=0
    pval = []
    sign_out = []
    names_out = []
    for roi in roifiles:
        print('Analysis of region '+rois[i])

        masker = NiftiMasker(roi, memory = 'nilearn_cache', memory_level = 1)
        fmri_masked = masker.fit_transform(imgs)
        y = fmri_masked.mean(1)
        sign_out.append(y)
        names_out.append('roi-'+rois[i])

        model = OLS(y, X)
        results = model.fit()
        print(results.tvalues)
        print(results.pvalues)

        i = i + 1

    sign_out = pd.DataFrame(sign_out)
    sign_out = sign_out.transpose()
    sign_out.columns = names_out
    sign_out.to_csv(folder_out+'/rois_exclusion-mean.csv', sep='\t', encoding='utf-8', header=True, index=False)



def load_covariates(score_file):
    fd_file = '/mnt/neuroimatge/neuroimatge/POLEX/covariates/fd_ratemepol_cent.csv'
    file = open(fd_file, 'r')
    fd = np.asarray(list(file.read().splitlines())).astype(float)

    age_file = '/mnt/neuroimatge/neuroimatge/POLEX/covariates/age_cent.csv'
    file = open(age_file, 'r')
    age = np.asarray(list(file.read().splitlines())).astype(float)

    fusion_file = "/mnt/neuroimatge/neuroimatge/POLEX/outputFiles/fusion_dych.csv"
    file = open(fusion_file, 'r')
    fusion = np.asarray(list(file.read().splitlines())).astype(float)
    fusion[fusion==-1] = 0

    gender_file = "/mnt/neuroimatge/neuroimatge/POLEX/outputFiles/gender.csv"
    file = open(gender_file, 'r')
    gender = np.asarray(list(file.read().splitlines())).astype(float)
    gender[gender==-1] = 0

    file = open(score_file, 'r')
    score = np.asarray(list(file.read().splitlines())).astype(float)

    X = np.stack((np.ones(len(fd)), fd, age, gender, fusion, score))
    return X.transpose()

