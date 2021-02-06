module "eks" {
  source = "./modules/eks"

  env                  = var.env
  region               = var.region
  profile              = var.profile
  private_subnet_ids   = aws_subnet.private.*.id

  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_version  = var.eks_cluster_version
  key_name             = aws_key_pair.eks-node.key_name
  ami_id               = data.aws_ami.eks-worker.id

  sg_eks_master_id     = aws_security_group.sg-eks-master.id
  sg_eks_node_id       = aws_security_group.sg-eks-node.id
  sg_admin_id          = aws_security_group.admin.id

  eks_node_instance_type = var.eks_node_instance_type
  eks_autoscaling        = var.eks_autoscaling
  spinnaker_managed      = true
}

