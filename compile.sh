#!/bin/bash

# name: compile.sh
# author: yuvalyehudab

BASE_DIR=/vol/scratch/`whoami`
ANACONDA_FILE=Anaconda3-2021.05-Linux-x86_64.sh

#check if conda in scratch
C_BIN=${BASE_DIR}/anaconda/bin/conda
C_INSTALL=${BASE_DIR}/${ANACONDA_FILE}
U_BASE=${BASE_DIR}/udocker
U_TAR=${BASE_DIR}/udocker-1.3.0.tar.gz

if [[ ! -f ${C_BIN} ]]; then
    # conda binary doesn't exist - install conda
    if [[ ! -d ${C_INSTALL} ]]; then
        # installation file doesn't exist - download it
        wget https://repo.anaconda.com/archive/${ANACONDA_FILE}
    fi
    bash ${ANACONDA_FILE} -b -p ${BASE_DIR}/anaconda -f
fi

if [[ ! -f ${U_BASE}/udocker ]]; then
    if [[ ! -f ${U_TAR} ]]; then
        curl -L https://github.com/indigo-dc/udocker/releases/download/v1.3.0/udocker-1.3.0.tar.gz \
         > ${U_TAR}
    fi
    tar zxf ${U_TAR}
fi


# conda init
eval "$(${C_BIN} shell.bash hook) 2> /dev/null"

# uncomment '-v' when debugging
set -e #-v

if [[ `conda info --env | grep udocker | awk '{ print $1 }'` == "udocker-gccpy" ]]; then
    ${C_BIN} create -y -q -n udocker-gccpy python=3.8
fi
conda activate udocker-gccpy

# think that this is not necessary
# export PATH=${BASE_DIR}/udocker:${PATH}

export UDOCKER_DIR=${BASE_DIR}/.udocker

${U_BASE}/udocker install

if [[ ! -f ./udocker ]]; then
    ln -s ${U_BASE} ./udocker 2> /dev/null
fi

# cancelled. replaced with direct script
# python compile.py

export U_BIN=${U_BASE}/udocker
${U_BIN} ps

if [[ -z $1 || ! -d $1 ]]; then
    exit
fi

if [[ ! -f $1/makefile && ! -f $1/Makefile ]]; then
    exit
fi

# if there is no container, create
if [[ -z `${U_BIN} ps | awk '{ print $4 }' | grep gccpy` ]]; then
    # if there is no image, pull
    if [[ ! `${U_BIN} images | awk '{print $1}' | grep gcc:latest` == "gcc:latest" ]]; then
        ${U_BIN} pull gcc:latest
    fi
    ${U_BIN} create --name=gcc gcc:latest
fi

# we have a container
# now run and compile
${U_BIN} run --volume=$1:$1 gcc cd $1 && make
