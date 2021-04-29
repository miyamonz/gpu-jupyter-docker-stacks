ARG BASE_CONTAINER
FROM $BASE_CONTAINER

LABEL maintainer="miyamonz"

# Install Tensorflow
RUN pip install --quiet --no-cache-dir \
    'tensorflow-gpu==1.15' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
