output "eks_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "eks_manage_instance_profile" {
  value = aws_iam_instance_profile.eks-manage-role.name
}
