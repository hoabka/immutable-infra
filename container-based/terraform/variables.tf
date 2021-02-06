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

variable "eks_cluster_name" {}
variable "eks_cluster_version" {}

variable "eks_node_instance_type" {}
variable "eks_autoscaling" {
  type = any
  default = {
    "desired" = 2
    "min"     = 2
    "max"     = 5
  }
}
variable "ssh_allow_cidr" {}
