account_id = "633834615594"
project    = "packer-demo"
env        = "demo"
profile    = "packer-demo"
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
number_web_instances  = 1
web_instance_type     = "t3.micro"
number_app_instances  = 1
app_instance_type     = "t3.micro"

ssh_allow_cidr        = "0.0.0.0/0"
