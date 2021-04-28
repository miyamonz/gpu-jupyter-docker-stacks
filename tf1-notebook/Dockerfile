ARG BASE_CONTAINER=miyamonz/scipy-notebook-cuda10.0-cudnn7-devel-ubuntu18.04
FROM $BASE_CONTAINER

LABEL maintainer="miyamonz"

# Install Tensorflow
RUN pip install --quiet --no-cache-dir \
    'tensorflow<2' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
