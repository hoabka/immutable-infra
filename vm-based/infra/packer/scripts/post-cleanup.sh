#!/usr/bin/env bash

set -o errexit
set -o pipefail
function terraform_destroy() {
  terraform destroy \
    -state="terraform.tfstate" \
    -auto-approve;
}

terraform_destroy
