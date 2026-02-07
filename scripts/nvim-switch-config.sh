#!/bin/bash
set -ex 
set -o pipefail

conf=${1}

sharedir=~/.local/share/nvim.${conf}
confdir=~/.config/nvim.${conf}

function relink() {
    newtarget=$1
    oldtarget=$2
    rm -f $oldtarget
    mkdir -p ${newtarget}
    ln -s $newtarget $oldtarget
}

function linkConf() {
    relink ${sharedir} ~/.local/share/nvim
    relink ${confdir} ~/.config/nvim
}

if [[ ! -d ${confdir} ]]; then
    echo "no confidir present ${confdir}"
    exit 1
fi

linkConf
