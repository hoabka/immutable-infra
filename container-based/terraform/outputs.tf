output "eks_cluster_name" {
  value = var.eks_cluster_name
  description = "EKS cluster name"
}

output "ecr_url" {
  value = aws_ecr_repository.ecr.repository_url
  description = "ECR url"
}