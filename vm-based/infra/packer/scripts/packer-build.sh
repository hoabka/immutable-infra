#!/usr/bin/env bash

set -o errexit
set -o pipefail
function build_image() {
    local role_name=$1
    export ROLE_NAME=${role_name}
    echo "ROLE NAME inside 1: $1"
    echo "ROLE NAME inside 2: $2"
    echo "ROLE NAME inside 3: $3"
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

echo "ROLE NAME in script: $1"
build_image $1
