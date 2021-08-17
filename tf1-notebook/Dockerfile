ARG BASE_CONTAINER
FROM $BASE_CONTAINER

LABEL maintainer="miyamonz"

USER root
RUN apt-get update && apt-get install -y \
curl \
mecab \
libmecab-dev \
mecab-ipadic-utf8 \
xz-utils \
file \
curl \
&& rm -rf /var/lib/apt/lists/*
USER ${NB_UID}

# Install Tensorflow
RUN pip install --quiet --no-cache-dir \
    fugashi \
    ipadic \
    mecab-python3 \
    transformers \
    'tensorflow-gpu==1.15' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
