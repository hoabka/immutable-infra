account_id = "633834615594"
project    = "container-based-cicd"
env        = "demo"
profile    = "demo"
region     = "us-west-2"

vpc_cidr               = "10.1.0.0/16"
number_public_subnets  = 3
number_private_subnets = 3
public_subnets_cidr    = {
  "0" : "10.1.0.0/24"
  "1" : "10.1.1.0/24"
  "2" : "10.1.2.0/24"
}
private_subnets_cidr    = {
  "0" : "10.1.10.0/24"
  "1" : "10.1.11.0/24"
  "2" : "10.1.12.0/24"
}

bastion_instance_type = "t3.micro"

eks_cluster_name       = "demo-eks-cluster"
eks_cluster_version    = "1.18"
eks_node_instance_type = "t3.medium"
eks_autoscaling        = {
    "desired" = 2
    "min"     = 2
    "max"     = 5
}

ssh_allow_cidr        = "0.0.0.0/0"
