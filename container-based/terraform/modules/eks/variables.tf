variable "region" {
  default = "us-west-2"
  description = "AWS region"
}

variable "env" {
  description = "Environment : dev/stg/prd"
}

variable "profile" {
  description = "AWS profile"
}

variable "private_subnet_ids" {
  description = "private subnet ids."
}

variable "eks_cluster_name" {
}

variable "eks_cluster_version" {}

variable "key_name" {
}

variable "ami_id" {}

variable "sg_eks_master_id" {}

variable "sg_eks_node_id" {}

variable "sg_admin_id" {}

variable "eks_node_instance_type" {}

variable "eks_autoscaling" {}

variable "spinnaker_managed" {
  default = true
  description = "Whether using managed spinnaker or not"
}
