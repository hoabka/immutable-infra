# Create spinnaker namespace
resource "kubernetes_namespace" "spinnaker" {
  metadata {
    name = var.spinnaker_k8s_namespace

    annotations = {
      # To ensure namespace is created only after previous module completes
      depends-id = var.rt_depends_on
    }
  }
}

# Create kubernetes service account for spinnaker
resource "kubernetes_service_account" "spinnaker" {
  depends_on = [
    kubernetes_namespace.spinnaker,
  ]

  metadata {
    name      = var.spinnaker_k8s_sa
    namespace = kubernetes_namespace.spinnaker.metadata.0.name
  }
}

data "template_file" "grant_admin_to_spinnaker" {
  template = <<EOF
set -ex \
&& kubectl create clusterrolebinding spinnaker-admin \
      --clusterrole=cluster-admin \
      --serviceaccount=$${namespace}:$${account}
EOF

  vars = {
    namespace = kubernetes_service_account.spinnaker.metadata.0.namespace
    account   = kubernetes_service_account.spinnaker.metadata.0.name
  }
}

# Grant ClusterRoleBinding to spinnaker service account
resource "null_resource" "grant_admin_to_spinnaker" {
  depends_on = [
    kubernetes_service_account.spinnaker,
  ]

  provisioner "local-exec" {
    command = data.template_file.grant_admin_to_spinnaker.rendered
  }
}

data "template_file" "kubectl_config" {
  depends_on = [
    null_resource.grant_admin_to_spinnaker,
  ]

  template = <<EOF
set -ex \
&& CONTEXT=$(kubectl config current-context) \
&& SECRET_NAME=$(kubectl get serviceaccount $${account} --namespace $${namespace} -o jsonpath='{.secrets[0].name}') \
&& TOKEN=$(kubectl get secret --namespace $${namespace} $SECRET_NAME -o yaml  -o jsonpath='{.data.token}' | base64 --decode) \
&& kubectl config set-credentials $CONTEXT-token-user --token $TOKEN \
&& kubectl config set-context $CONTEXT --user $CONTEXT-token-user
EOF

  vars = {
    namespace = kubernetes_service_account.spinnaker.metadata.0.namespace
    account   = kubernetes_service_account.spinnaker.metadata.0.name
  }
}

# Configure kubectl to use spinnaker service account
resource "null_resource" "kubectl_config" {
  depends_on = [
    null_resource.grant_admin_to_spinnaker,
  ]

  provisioner "local-exec" {
    command = data.template_file.kubectl_config.rendered
  }
}

data "template_file" "deploy_spinnaker" {
  template = <<EOF
set -ex \
&& hal -q config provider kubernetes enable \
&& hal -q config provider kubernetes account delete my-k8s-v2-account || true \
&& hal -q config provider kubernetes account add my-k8s-v2-account --provider-version v2 --context $(kubectl config current-context) \
&& hal -q config version edit --version $${spinnaker_version} \
&& hal -q config storage s3 edit --bucket $${s3bucket} --assume-role $${managed_role_arn} \
&& hal -q config storage edit --type s3 \
&& hal -q deploy apply
EOF

  vars = {
    project           = var.project
    s3bucket          = var.s3bucket
    managed_role_arn  = aws_iam_role.spinnaker-managed.arn
    spinnaker_version = var.spinnaker_version
  }
}

# Configure kubectl to use spinnaker service account
resource "null_resource" "deploy_spinnaker" {

  provisioner "local-exec" {
    command = data.template_file.deploy_spinnaker.rendered
  }
}
