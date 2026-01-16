FROM picker24/nuisance2_git_master:alma9

RUN dnf install -y python3-markdown python3-matplotlib python3-pyarrow lynx unzip && \
    pip3 install jupyterlab==4.1.6 && pip3 install pandas==2.1.4 polars ipywidgets numpy==1.22.4 scipy==1.13.1

RUN mkdir -p /opt/utils
ADD utils/halp \
  /opt/utils

RUN chmod +x /opt/utils/*
ENV PATH=/opt/utils:${PATH} \
    OMP_NUM_THREADS=1