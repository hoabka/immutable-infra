variable "project" {
  description = "project name"
}

variable "spinnaker_k8s_namespace" {
  description = "Name of spinnaker namespace"
}

variable "rt_depends_on" {
  description = "Depends on other modules"
}

variable "spinnaker_k8s_sa" {
  description = "Service Account name"
}

variable "spinnaker_version" {
  description = "Spinnaker version"
}

variable "s3bucket" {
  description = "S3 bucket to store Spinnaker artifacts"
}

