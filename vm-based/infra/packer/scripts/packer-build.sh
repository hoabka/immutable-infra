#!/usr/bin/env bash

set -o errexit
set -o pipefail
function build_image() {
    export ROLE_NAME=$1
    echo ${ROLE_NAME}
    #Inspect script
    packer \
    inspect \
      packer.json \
    ;

    #Validate packer script
    packer \
    validate \
      -var-file "variables.json" \
      packer.json \
    ;
    #Packaging image
    packer \
    build \
      -var-file "variables.json" \
      packer.json \
      -debug       \
    ;
}
echo $1
build_image $1
