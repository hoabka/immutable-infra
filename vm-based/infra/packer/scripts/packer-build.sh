#!/usr/bin/env bash

set -o errexit
set -o pipefail
function build_image() {
    role_name=$1
    export role_name=${role_name}
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
    ;
}

build_image
