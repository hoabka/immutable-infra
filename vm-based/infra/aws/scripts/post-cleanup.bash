#!/usr/bin/env bash

set -o errexit
set -o pipefail
terraform destroy \
    -state="terraform.tfstate" \
    -auto-approve;