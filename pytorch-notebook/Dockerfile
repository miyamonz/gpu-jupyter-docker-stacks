ARG BASE_CONTAINER
FROM $BASE_CONTAINER

LABEL maintainer="miyamonz"

# Install Tensorflow
RUN pip install --quiet --no-cache-dir \
    'torch==1.8.0' \
    'torchvision==0.9.0' \
    'torchaudio==0.8.0' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
