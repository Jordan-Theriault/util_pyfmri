from jtnipyutil.fsmap import create_aqueduct_template, make_PAG_masks, create_DARTEL_wf
import os

subj_list = ['sub-001','sub-002','sub-003','sub-004','sub-005','sub-006','sub-007','sub-008','sub-009','sub-010']

# create aqueduct template.
p_thresh_list = [95, 97.5, 90, 85]
variance_template = '/scratch/data/sub-*/model/sub-*/_modelestimate0/sigmasquareds.nii.gz'
work_dir = '/scratch/wrkdir'
data_dir = '/scratch/data'
out_dir = '/scratch/output'
space_mask =  '/scratch/wrkdir/search_region.nii'
create_aqueduct_template(subj_list, p_thresh_list, variance_template, work_dir, out_dir, space_mask)

# use aqueduct template to create PAG masks
aqueduct_template = os.path.join(work_dir, 'templates', '*_aqueduct_template.nii.gz')
gm_template = os.path.join(data_dir, 'gm', '*_T1w_space-MNI152NLin2009cAsym_class-GM_probtissue.nii.gz')
y_minmax = [82,100]
z_minmax = [58,176]
make_PAG_masks(subj_list, aqueduct_template, gm_template, work_dir, out_dir, y_minmax=y_minmax, z_minmax=z_minmax)

# warp PAG masks into an average space.
PAG_template = os.path.join(work_dir, 'pag_mask', '*_pag_mask.nii')
PAG_DARTEL = create_DARTEL_wf(subj_list, PAG_template, work_dir, out_dir)
PAG_DARTEL.run(plugin='MultiProc')
