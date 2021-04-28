#!/bin/bash
OWNER=miyamonz

CUDA_VERSION=10.1
TYPE=cudnn7-devel
BASE_OS=ubuntu18.04

get_base_container() {
    if [[ $1 = "" ]]; then
        exit 1
    fi
    if [[ $1 = "base-notebook" ]]; then
        exit 1
    fi
    cat docker-stacks/${1}/Dockerfile | grep 'ARG BASE_CONTAINER' | cut -d '=' -f 2 | cut -d / -f 2
}
# get_base_container minimal-notebook

build() {
    local NB_NAME=$1
    if [[ $NB_NAME = "" ]]; then
        echo build argument needed
        exit 1
    fi
    local CUDA_TAG=${CUDA_VERSION}-${TYPE}-${BASE_OS}
    local SUFFIX="cuda$CUDA_TAG"
    local IMAGE_NAME="${OWNER}/${NB_NAME}"-${SUFFIX}

    local ROOT_CONTAINER=nvidia/cuda:${CUDA_TAG}
    local BUILD_ARG="ROOT_CONTAINER=${ROOT_CONTAINER}"
    if [[ $NB_NAME = "base-notebook" ]]; then
        :
    else
        local BASE_CONTAINER=`get_base_container $NB_NAME`
        build $BASE_CONTAINER
        BUILD_ARG+=" BASE_CONTAINER=${OWNER}/${BASE_CONTAINER}-${SUFFIX}"
    fi
    BUILD_ARG=`echo $BUILD_ARG | tr ' ' "\n" | awk '{print "--build-arg " $0}' | tr "\n" ' '`
    echo building $IMAGE_NAME ....
    local BUILD_COMMAND="docker build ${DARGS} ${BUILD_ARG} --rm --force-rm -t ${IMAGE_NAME}:latest ./docker-stacks/${NB_NAME}"
    echo $BUILD_COMMAND
    eval $BUILD_COMMAND
    echo -n "Built image size: "
    docker images ${IMAGE_NAME}:latest --format "{{.Size}}"
    echo built $IMAGE_NAME
    echo
}
build minimal-notebook
