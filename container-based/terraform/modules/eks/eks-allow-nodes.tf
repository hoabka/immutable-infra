#Spinnaker service account
data "template_file" "kube-config" {
  template = "${file("${path.module}/userdata/kube-config.tpl")}"

  vars = {
    cluster_name        = var.eks_cluster_name
    cluster_arn         = aws_eks_cluster.eks-cluster.arn
    node_pool_role_arn  = aws_iam_role.eks-node.arn
    eks_manage_role_arn = aws_iam_role.eks-manage-role.arn
    aws_region          = var.region
    aws_profile         = var.profile
    spinnaker_managed   = var.spinnaker_managed
  }
}

resource "local_file" "update_kubeconfig" {
  content  = data.template_file.kube-config.rendered
  filename = "${path.cwd}/${var.eks_cluster_name}/update-kubeconfig.sh"
}

resource "null_resource" "apply_kubeconfig" {

  #Convert DOS to Unix in case of Linux Subsystem on Window 10
  provisioner "local-exec" {
    command = "sed -i 's/\r$//' ${path.cwd}/${var.eks_cluster_name}/update-kubeconfig.sh"
  }

  #
  provisioner "local-exec" {
    command = "/bin/bash ${path.cwd}/${var.eks_cluster_name}/update-kubeconfig.sh"
  }
}
