module "spinnaker" {
  source                  = "./modules/spinnaker"

  project                 = var.project
  spinnaker_k8s_namespace = "spinnaker"
  rt_depends_on           = module.eks.eks_cluster_id
  spinnaker_k8s_sa        = "managed-spinnaker-sa"
  spinnaker_version       = "1.22.4"
  s3bucket                = "packer-demo"
}
