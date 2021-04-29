#!/bin/bash
OWNER=miyamonz
REPOROOT="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

require() {
    local NAME=$1
    if [ -z ${!NAME} ] ; then
        echo specify $NAME 
        exit 1
    fi
}
require CUDA_TAG
require SUFFIX
ROOT_CONTAINER=nvidia/cuda:${CUDA_TAG}

get_base_container() {
    if [[ $1 = "" ]]; then
        exit 1
    fi
    if [[ $1 = "base-notebook" ]]; then
        exit 1
    fi
    cat $REPOROOT/docker-stacks/${1}/Dockerfile | grep 'ARG BASE_CONTAINER' | cut -d '=' -f 2 | cut -d / -f 2
}

to_image_name() {
    echo ${OWNER}/${1}-${SUFFIX}
}
to_build_arg() {
    # split space and append --build-arg
    echo "$@" | tr ' ' "\n" | awk '{print "--build-arg " $0}' | tr "\n" ' '
}

build() {
    local NB_NAME=$1
    if [[ $NB_NAME = "" ]]; then
        echo notebook name required  
        exit 1
    fi
    local IMAGE_NAME=$(to_image_name $NB_NAME)

    local BUILD_ARG=""
    if [[ $NB_NAME = "base-notebook" ]]; then
        BUILD_ARG+=" ROOT_CONTAINER=${ROOT_CONTAINER}"
        BUILD_ARG+=" PYTHON_VERSION=${PYTHON_VERSION:-default}"
    else
        local BASE_CONTAINER=$(get_base_container $NB_NAME)
        build $BASE_CONTAINER
        BUILD_ARG+=" BASE_CONTAINER=$(to_image_name $BASE_CONTAINER)"
    fi
    BUILD_ARGS=$(to_build_arg $BUILD_ARG)

    echo building $IMAGE_NAME ....
    local BUILD_COMMAND="docker build ${DARGS} ${BUILD_ARGS} --rm --force-rm -t ${IMAGE_NAME}:latest $REPOROOT/docker-stacks/${NB_NAME}"
    echo $BUILD_COMMAND
    eval $BUILD_COMMAND
    echo built $IMAGE_NAME
    echo
}

build $1
