resource "tls_private_key" "bastion" {
  algorithm = "RSA"
}

resource "local_file" "bastion" {
  filename          = "${local.private_keyname_path}/bastion.pem"
  sensitive_content = tls_private_key.bastion.private_key_pem
  file_permission   = "0400"
}

resource "aws_key_pair" "bastion" {
  public_key = tls_private_key.bastion.public_key_openssh
  key_name   = "bastion_key"
}

resource "tls_private_key" "eks-node" {
  algorithm = "RSA"
}

resource "local_file" "eks-node" {
  filename          = "${local.private_keyname_path}/eks-node.pem"
  sensitive_content = tls_private_key.eks-node.private_key_pem
  file_permission   = "0400"
}

resource "aws_key_pair" "eks-node" {
  public_key = tls_private_key.eks-node.public_key_openssh
  key_name   = "eks-node_key"
}
