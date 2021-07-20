#!/bin/bash
REPOROOT=$(realpath $(dirname $0)/..)
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
OWNER=miyamonz

CUDA_VERSION=11.1
TYPE=cudnn8-devel
BASE_OS=ubuntu20.04
CUDA_TAG=${CUDA_VERSION}-${TYPE}-${BASE_OS}

SUFFIX="cuda$CUDA_TAG"

CUDA_TAG=${CUDA_TAG} \
SUFFIX=${SUFFIX} \
PYTHON_VERSION=${PYTHON_VERSION} \
    $REPOROOT/build.bash scipy-notebook

BASE_CONTAINER=${OWNER}/scipy-notebook-${SUFFIX}

NB_NAME=pytorch-notebook
IMAGE_NAME=${OWNER}/${NB_NAME}-${SUFFIX}
docker build --build-arg BASE_CONTAINER=$BASE_CONTAINER --rm --force-rm -t $IMAGE_NAME:latest $SCRIPTPATH
docker tag $IMAGE_NAME $OWNER/${NB_NAME}-gpu
echo $OWNER/${NB_NAME}-gpu > $SCRIPTPATH/.tag
