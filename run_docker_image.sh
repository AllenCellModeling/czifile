#!/usr/bin/env bash

TAG=${1%/}
PORT=${2}
TBPORT=${3}

docker run --rm -ti --ipc=host \
    -e "PASSWORD=jupyter1" \
    -p ${PORT}:9999 \
    -p ${TBPORT}:6006 \
    -v /allen/aics/modeling/gregj/results:/root/data \
    -v /allen/aics:/root/aics \
    jamies/czifile:${TAG} \
    bash -c "/opt/conda/bin/jupyter lab --allow-root --NotebookApp.iopub_data_rate_limit=10000000000"
