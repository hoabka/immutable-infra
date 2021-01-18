data "aws_ami" "bastion" {
  most_recent      = true
  filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 18.04 LTS*",]
  }

  filter {
    name   = "root-device-type"
    values = [
      "ebs",
    ]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "eks-worker" {
  most_recent = true
  filter {
    name = "root-device-type"
    values = [
      "ebs",
    ]
  }

  filter {
    name = "name"
    values = ["amazon-eks-node-${var.eks_cluster_version}-v*"]
  }

  owners = [
    "amazon"
  ]
}
