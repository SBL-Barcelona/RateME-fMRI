import numpy as np
import nibabel as nib
import os
from nilearn.masking import apply_mask
from pathlib import Path

def filter_atlas(atlasName, maskName, thr = 0):
    
    ## Load nifti data and matrices
    print('Filtering atlas with binary mask...')


    mask = nib.load(maskName)
    atlas = nib.load(atlasName)
    
    matAtlas = atlas.get_fdata()
    matAtlas = np.round(matAtlas)
    yAtlas = matAtlas[matAtlas != 0]
    y = apply_mask(atlas, mask)
    y = np.round(y)
    
    
    ### Get indices of regions with proportion of voxels in mask over threshold
    
    unAtlas, countAtlas = np.unique(yAtlas, return_counts=True)
    unMask, countMask = np.unique(y, return_counts=True)
    prop = [countMask[i]/countAtlas[unAtlas==unMask[i]] for i in range(len(countMask))]
    finalIndices = [unMask[i] for i in range(len(unMask)) if prop[i] > thr]
    try:
        finalIndices.remove(15)
    except ValueError:
        print('No white matter found')
    
    ### Create empty atlas and fill only with regions of computed indices
    
    finalAtlas = np.zeros(matAtlas.shape)
    for i in finalIndices:
        finalAtlas[matAtlas==i] = i
    
    
    ### Create output nifti object and output filename

    outImage = nib.Nifti1Image(finalAtlas, atlas.affine)
    
    folder, maskName = os.path.split(maskName)
    maskName = Path(maskName)
    maskName = str(maskName).rstrip(''.join(maskName.suffixes))
    
    folder, atlasName = os.path.split(atlasName)
    atlasName = Path(atlasName)
    atlasName = str(atlasName).rstrip(''.join(atlasName.suffixes))
    
    outName = maskName + '_' + atlasName
    
    nib.save(outImage, os.path.join(folder, outName + '.nii.gz'))

    print('Filtered atlas saved in '+os.path.join(folder, outName + '.nii.gz'))
