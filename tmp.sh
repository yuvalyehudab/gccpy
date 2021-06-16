#!/bin/bash 

# tmp.sh

UDOCKER_DIR=/vol/scratch/yuvalyehudab/test/udocker


if [[ `/vol/scratch/yuvalyehudab/udocker/udocker images | awk '{print $1}' | grep gcc:latest` == "gcc:latest" ]]; then
    echo `/vol/scratch/yuvalyehudab/udocker/udocker images | awk '{print $1}'`
fi
