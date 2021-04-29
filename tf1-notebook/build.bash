#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

OWNER=miyamonz

CUDA_VERSION=10.0
TYPE=cudnn7-devel
BASE_OS=ubuntu18.04
CUDA_TAG=${CUDA_VERSION}-${TYPE}-${BASE_OS}

NB_NAME=tf1-notebook

build() {
    local SUFFIX="cuda$CUDA_TAG"
    local IMAGE_NAME="${OWNER}/${NB_NAME}"-${SUFFIX}

    local ROOT_CONTAINER=nvidia/cuda:${CUDA_TAG}
    local BUILD_ARG="ROOT_CONTAINER=${ROOT_CONTAINER}"

    local BASE_CONTAINER=scipy-notebook
    BUILD_ARG+=" BASE_CONTAINER=${OWNER}/${BASE_CONTAINER}-${SUFFIX}"

    BUILD_ARG=`echo $BUILD_ARG | tr ' ' "\n" | awk '{print "--build-arg " $0}' | tr "\n" ' '`

    echo building $IMAGE_NAME ....
    local BUILD_COMMAND="docker build ${DARGS} ${BUILD_ARG} --rm --force-rm -t ${IMAGE_NAME}:latest ${SCRIPTPATH}"
    echo $BUILD_COMMAND
    eval $BUILD_COMMAND
    echo -n "Built image size: "
    docker images ${IMAGE_NAME}:latest --format "{{.Size}}"
    echo built $IMAGE_NAME
    echo
}
build 
