resource "aws_eks_cluster" "eks-cluster" {
  name = var.eks_cluster_name
  role_arn = aws_iam_role.eks-master.arn


  vpc_config {
    security_group_ids = [var.sg_eks_master_id]

    subnet_ids = var.private_subnet_ids
  }

  depends_on = [
    aws_iam_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}

