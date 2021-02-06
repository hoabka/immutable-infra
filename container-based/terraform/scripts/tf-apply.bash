#!/usr/bin/env bash

terraform init
terraform validate
terraform plan
terraform apply --auto-approve
