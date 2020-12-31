#!/usr/bin/env bash

date

ansible-playbook \
  --inventory-file ansible-hosts.yml \
  --tags "deployment" \
    "${BASE_DIR_PATH}/ansible/initial-deployment.yml" \
    ;