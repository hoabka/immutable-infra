variable "account_id" {}
variable "project" {}
variable "env" {}
variable "profile" {}
variable "region" {}

variable "vpc_cidr" {}
variable "number_public_subnets" {}
variable "number_private_subnets" {}
variable "public_subnets_cidr" {}
variable "private_subnets_cidr" {}

variable "bastion_instance_type" {}
variable "number_web_instances" {}
variable "web_instance_type" {}
variable "number_app_instances" {}
variable "app_instance_type" {}

variable "ssh_allow_cidr" {}