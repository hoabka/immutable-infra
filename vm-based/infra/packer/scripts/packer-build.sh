#!/usr/bin/env bash

set -o errexit
set -o pipefail
function build_image() {
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

echo $ROLE_NAME
build_image
