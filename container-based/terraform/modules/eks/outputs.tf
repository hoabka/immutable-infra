output "eks_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
  description = "EKS endpoint"
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks-cluster.id
  description = "EKS cluster id"

}

output "eks_manage_instance_profile" {
  value = aws_iam_instance_profile.eks-manage-role.name
  description = "Instance profile for bastion to manage eks cluster"
}
