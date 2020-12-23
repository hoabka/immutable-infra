
FROM ubuntu:18.04

ARG TERRAFORM_VERSION=0.12.24
ARG PACKER_VERSION=1.5.6

ENV ENV_TERRAFORM_VERSION=${TERRAFORM_VERSION}
ENV ENV_PACKER_VERSION=${PACKER_VERSION}

RUN apt-get update --yes && \
    apt-get install --yes \
      curl \
      python3-pip \
      unzip \
      wget \
    && rm --recursive --force /var/lib/apt/lists/*

RUN pip3 install --upgrade \
  ansible;

RUN apt-get clean --yes \
  && rm --recursive --force /var/lib/apt/lists/*


RUN curl --output "terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip" \
  --silent \
  --show-error \
  --location \
    "https://releases.hashicorp.com/terraform/${ENV_TERRAFORM_VERSION}/terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip"
RUN unzip "terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip" \
  && rm --force "terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip"
RUN chmod +x terraform
RUN mv terraform /usr/local/bin

RUN curl --output "packer_${ENV_PACKER_VERSION}_linux_amd64.zip" \
  --silent \
  --show-error \
  --location \
    "https://releases.hashicorp.com/packer/${ENV_PACKER_VERSION}/packer_${ENV_PACKER_VERSION}_linux_amd64.zip"
RUN unzip "packer_${ENV_PACKER_VERSION}_linux_amd64.zip" \
  && rm --force "packer_${ENV_PACKER_VERSION}_linux_amd64.zip"
RUN chmod +x packer
RUN mv packer /usr/local/bin
