docker run --rm kaczmarj/neurodocker:master generate docker \
--base debian:stretch --pkg-manager apt \
--install gcc g++ graphviz tree \
          git vim emacs-nox nano less ncdu \
          tig openjdk-8-jdk \
--run "export JCC_JDK=/usr/lib/jvm/java-8-openjdk-amd64" \
--fsl version=5.0.11 \
--ants version=2.2.0 \
--convert3d version=1.0.0 \
--freesurfer version=6.0.0 \
--afni version=latest \
--spm version=r7219 \
--miniconda create_env=py36 \
  conda_install="python=3.6 jupyter jupyterlab jupyter_contrib_nbextensions
                 traits pandas matplotlib scikit-learn==0.22.2.post1 seaborn" \
  pip_install="https://github.com/nipy/nipype/tarball/1.4.2
               https://github.com/INCF/pybids/tarball/0.9.4
               nltools nilearn nistats datalad[full] nipy duecredit niwidgets
               mne deepdish hypertools ipywidgets pynv six nibabel joblib==0.11" \
  activate=True \
--copy jtnipyutil /opt/miniconda-latest/envs/py36/lib/python3.6/site-packages/jtnipyutil
