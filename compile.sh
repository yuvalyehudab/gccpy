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

# uncomment when debugging
# set -ev

${C_BIN} create -y -q -n udocker python=3.8
conda activate udocker

# think that this is not necessary
# export PATH=${BASE_DIR}/udocker:${PATH}

export UDOCKER_DIR=${BASE_DIR}/.udocker

${U_BASE}/udocker install

ln -s ${U_BASE} ./udocker 2> /dev/null

python compile.py
