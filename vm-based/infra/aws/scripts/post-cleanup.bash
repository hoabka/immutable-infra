#!/usr/bin/env bash

set -o errexit
set -o pipefail
terraform destroy \
    -auto-approve;