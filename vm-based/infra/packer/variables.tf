variable "project" {
  default = "packer"
}

variable "region" {
  default = "us-west-2"
}

variable "profile" {
  default = "packer-demo"
}

variable "vpc_name" {
  default = "packer-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = {
    "0" : "10.0.0.0/24"
    "1" : "10.0.0.1/24"
    "2" : "10.0.0.2/24"
  }
}

variable "build_number" {
  description = "Jenkin build number"
  default = 1
}

variable "private_keyname" {
  description = "private keyname"
  default = "packer_id_rsa"
}

variable "ami_spec" {
  description = "AMI spec"
  default = {
    "instance_type"        = "t3.micro"
    "ami_desc"             = "Canonical, Ubuntu, 18.04 LTS*"
    "ami_owner"            = "099720109477"
    "volume_type"          = "gp2"
    "volume_size"          = "20"
    "packer_remote_user"   = "ubuntu"
  }
}

variable "ansible_dir_path" {
  description = "Ansible dir path"
  default = "../.."
}

