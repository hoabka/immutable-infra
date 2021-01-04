#!/usr/bin/env bash

date

ansible-playbook \
  --inventory-file ansible-hosts.yml \
  --tags "deployments" \
    "../../ansible/initial-deployment.yml" \
    ;