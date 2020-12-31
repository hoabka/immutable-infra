#!/usr/bin/env bash

date

ansible-playbook \
  --inventory-file ansible-hosts.yml \
  --tags "deployment" \
    "../../ansible/initial-deployment.yml" \
    ;