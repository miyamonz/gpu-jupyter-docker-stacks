#!/bin/bash
REPOROOT=$(realpath $(dirname $0)/..)
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
OWNER=miyamonz

CUDA_VERSION=10.0
TYPE=cudnn7-devel
BASE_OS=ubuntu18.04
CUDA_TAG=${CUDA_VERSION}-${TYPE}-${BASE_OS}

PYTHON_VERSION=3.7
SUFFIX="py${PYTHON_VERSION}-cuda$CUDA_TAG"

CUDA_TAG=${CUDA_TAG} \
SUFFIX=${SUFFIX} \
PYTHON_VERSION=${PYTHON_VERSION} \
    $REPOROOT/build.bash scipy-notebook

BASE_CONTAINER=${OWNER}/scipy-notebook-${SUFFIX}
IMAGE_NAME=${OWNER}/tf1-notebook-${SUFFIX}
docker build --build-arg BASE_CONTAINER=$BASE_CONTAINER --rm --force-rm -t $IMAGE_NAME:latest $SCRIPTPATH
