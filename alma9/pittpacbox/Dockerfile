FROM picker24/nuisance2_git_master:alma9

RUN dnf install -y python3-markdown lynx

RUN mkdir -p /opt/utils
ADD utils/help \
  /opt/utils

RUN chmod +x /opt/utils/*
ENV PATH=/opt/utils:${PATH}