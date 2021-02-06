#!/usr/bin/env bash

terraform init
terraform plan
terraform validate
terraform apply --auto-approve
