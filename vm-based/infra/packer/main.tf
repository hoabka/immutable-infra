<<<<<<< HEAD
provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = var.profile
}

terraform {
  required_version = ">= 0.12.24"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  timestamp             = formatdate("YYYYMMDD-hhmmss", timestamp())
  number_azs            = length(data.aws_availability_zones.available.names)
  common_tags           = "packer-ami-${var.build_number}-${local.timestamp}"
  private_keyname_path  = "${path.root}/keys/${var.private_keyname}"
}

resource "random_shuffle" "random_azs" {
  input = data.aws_availability_zones.available.names
  result_count = local.number_azs
}

resource "tls_private_key" "packer" {
  algorithm = "RSA"
}

resource "local_file" "packer" {
  filename = local.private_keyname_path
  sensitive_content = tls_private_key.packer.private_key_pem
}

resource "aws_key_pair" "packer" {
  public_key = tls_private_key.packer.public_key_openssh
  key_name = "packer-key"
}

resource "aws_vpc" "packer" {
  cidr_block = ""
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(
    {
      Name = "packer-vpc"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "aws_internet_gateway" "packer" {
  vpc_id = aws_vpc.packer.id

  tags = merge(
    {
      Name = "packer-igw"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.packer.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.packer.id
  }
  tags = merge(
    {
      Name = "packer-pub-rt"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "aws_subnet" "packer" {
  vpc_id            = aws_vpc.packer.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = random_shuffle.random_azs.result

  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "packer-pub-subnet"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "aws_security_group" "allow-ssh" {
  name = "allow ssh"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    {
      Name = "allow_ssh_sg"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "local_file" "packer-variables" {
  content = templatefile("${path.root}/variables.json.tpl", {
    region_name            = var.region
    vpc_id                 = aws_vpc.packer.id
    subnet_id              = aws_subnet.packer.id
    private_key            = local.private_keyname_path
    public_key             = aws_key_pair.packer.key_name
    security_groups        = aws_security_group.allow-ssh.name
    instance_type          = lookup(var.ami_spec, "instance_type")
    ami_desc               = lookup(var.ami_spec, "ami_desc")
    ami_owner              = lookup(var.ami_spec, "ami_owner")
    volume_type            = lookup(var.ami_spec, "volume_type")
    volume_size            = lookup(var.ami_spec, "volume_size")
    remote_user            = lookup(var.ami_spec, "remote_user")
    ansible_dir_path       = var.ansible_dir_path
  }
)

  filename = "${path.root}/variables.json"
  file_permission = "0600"
}




=======
provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = var.profile
}

terraform {
  required_version = ">= 0.12.24"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  timestamp             = formatdate("YYYYMMDD-hhmmss", timestamp())
  number_azs            = length(data.aws_availability_zones.available.names)
  common_tags           = {"CommonTags": "packer-ami-${var.build_number}-${local.timestamp}"}
  private_keyname_path  = "${path.root}/keys/${var.private_keyname}"
}

resource "random_shuffle" "random_azs" {
  input = data.aws_availability_zones.available.names
  result_count = local.number_azs
}

resource "tls_private_key" "packer" {
  algorithm = "RSA"
}

resource "local_file" "packer" {
  filename = local.private_keyname_path
  sensitive_content = tls_private_key.packer.private_key_pem
}

resource "aws_key_pair" "packer" {
  public_key = tls_private_key.packer.public_key_openssh
  key_name = "packer-key"
}

resource "aws_vpc" "packer" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(
    {
      Name = "packer-vpc"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "aws_internet_gateway" "packer" {
  vpc_id = aws_vpc.packer.id

  tags = merge(
    {
      Name = "packer-igw"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.packer.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.packer.id
  }
  tags = merge(
    {
      Name = "packer-pub-rt"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "aws_subnet" "packer" {
  vpc_id            = aws_vpc.packer.id
  cidr_block        = var.public_subnet_cidr[0]
  availability_zone = random_shuffle.random_azs.result[0]

  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "packer-pub-subnet"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "aws_route_table_association" "packer" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.packer.id
}

resource "aws_security_group" "allow-ssh" {
  name = "allow ssh"
  vpc_id = aws_vpc.packer.id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    {
      Name = "allow_ssh_sg"
      Env  = "demo"
    }, local.common_tags
  )
}

resource "local_file" "packer-variables" {
  content = templatefile("${path.root}/variables.json.tpl", {
    region_name            = var.region
    vpc_id                 = aws_vpc.packer.id
    subnet_id              = aws_subnet.packer.id
    private_key            = local.private_keyname_path
    public_key             = aws_key_pair.packer.key_name
    security_group_id      = aws_security_group.allow-ssh.id
    instance_type          = lookup(var.ami_spec, "instance_type")
    ami_desc               = lookup(var.ami_spec, "ami_desc")
    ami_owner              = lookup(var.ami_spec, "ami_owner")
    volume_type            = lookup(var.ami_spec, "volume_type")
    volume_size            = lookup(var.ami_spec, "volume_size")
    packer_remote_user     = lookup(var.ami_spec, "packer_remote_user")
    ansible_dir_path       = var.ansible_dir_path
  }
)

  filename = "${path.root}/variables.json"
  file_permission = "0600"
}




>>>>>>> upstream/main
