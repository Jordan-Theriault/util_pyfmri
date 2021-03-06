#!/bin/tcsh
setenv SUBJ sub-$1
setenv TASK rest_run-01
setenv PROJNAME nighres_roi
setenv DEPTH ${SUBJ}_space-MNI152NLin2009cAsym_depth_layering-depth.nii.gz
setenv IMG ${SUBJ}_task-rest_run-01_bold_space-MNI152NLin2009cAsym_preproc.nii.gz
setenv CONFOUND ${SUBJ}_task-rest_run-01_bold_confounds.tsv
setenv SINGULARITY /usr/bin/singularity
setenv IMAGE /autofs/cluster/iaslab/users/jtheriault/singularity_images/nighres/nighres-2019-05-07-9ae9dfd9c326.simg
setenv ATLAS COMBINED_DILATED1mm_Glasser_atlas_2009cAsym.nii.gz

setenv LAMINAR_DATA /autofs/cluster/iaslab/users/jtheriault/FSMAP/laminar/
setenv RAW_DATA /autofs/cluster/iaslab/FSMAP/FSMAP_data/BIDS_fmriprep/fmriprep/ses-01
setenv SCRIPTS /autofs/cluster/iaslab/users/jtheriault/FSMAP/laminar/scripts
setenv OUTPUT /autofs/cluster/iaslab/users/jtheriault/FSMAP/laminar/atlas_roi_data

mkdir -p /scratch/$USER/$SUBJ/$PROJNAME/data
cp -ra $RAW_DATA/$SUBJ/func/$IMG /scratch/$USER/$SUBJ/$PROJNAME/data/
cp -ra $RAW_DATA/$SUBJ/func/$CONFOUND /scratch/$USER/$SUBJ/$PROJNAME/data/
cp -ra $LAMINAR_DATA/depth/$DEPTH /scratch/$USER/$SUBJ/$PROJNAME/data/
cp -a $LAMINAR_DATA/rois/$ATLAS /scratch/$USER/$SUBJ/$PROJNAME/data/

mkdir -p /scratch/$USER/$SUBJ/$PROJNAME/scripts
cp -ra $SCRIPTS/* /scratch/$USER/$SUBJ/$PROJNAME/scripts/
chmod +x /scratch/$USER/$SUBJ/$PROJNAME/scripts/*

mkdir -p /scratch/$USER/$SUBJ/$PROJNAME/nighres

cd /scratch/$USER

$SINGULARITY exec \
--bind "/scratch:/scratch" \
$IMAGE \
/scratch/$USER/$SUBJ/$PROJNAME/scripts/startup_laminar_mask_from_atlas.sh

rsync -ra /scratch/$USER/$SUBJ/$PROJNAME/nighres/depth10* $OUTPUT/
rsync -ra /scratch/$USER/$SUBJ/$PROJNAME/nighres/depth3* $OUTPUT/
rsync -ra /scratch/$USER/$SUBJ/$PROJNAME/nighres/CORR_PSC_w_DEPTH_* $OUTPUT/
rsync -ra /scratch/$USER/$SUBJ/$PROJNAME/nighres/correlation* $OUTPUT/

rm -r /scratch/$USER/$SUBJ/$PROJNAME
exit
