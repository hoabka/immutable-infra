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
