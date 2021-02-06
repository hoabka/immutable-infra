#!/bin/bash -xe

SPIN_MANAGED=${spinnaker_managed}
NAMESPACE=${aws_region}
CONTEXT=${cluster_name}

### update kubeconfig
function kube_config () {
  aws eks update-kubeconfig --name ${cluster_name} --profile ${aws_profile} --no-verify-ssl
  # change the context of kubernetes cluster
  kubectl config use-context ${cluster_arn}
    # register worker nodes to master
  cat  << EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${node_pool_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: ${eks_manage_role_arn}
      username: ${cluster_arn}
      groups:
        - system:masters
EOF
}

### create a service account and namespace
function kube_role () {
  kubectl describe namespace $NAMESPACE && echo "Namespace already exists" || kubectl create namespace $NAMESPACE

  cat  << EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: spinnaker-service-account
  namespace: $NAMESPACE
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: spinnaker-managed
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: spinnaker-service-account
  namespace: $NAMESPACE
EOF

  TOKEN=$(kubectl get secret \
            $(kubectl get serviceaccount spinnaker-service-account \
               -n $NAMESPACE \
               -o jsonpath='{.secrets[0].name}') \
           -n $NAMESPACE \
           -o jsonpath='{.data.token}' | base64 --decode)

  kubectl config set-credentials ${cluster_name}-sa --token $TOKEN
  kubectl config set-context $CONTEXT --cluster=${cluster_arn} --user=${cluster_name}-sa --namespace=$NAMESPACE
  kubectl config use-context $CONTEXT

  minify $CONTEXT
}

### make minified kubeconfig
function minify () {
  # Create a full copy
  kubectl config view --raw > $KUBECONFIG.full.tmp

  # Switch working context to target context
  kubectl --kubeconfig $KUBECONFIG.full.tmp config use-context $1

  # Minify
  kubectl --kubeconfig $KUBECONFIG.full.tmp \
    config view --flatten --minify > $KUBECONFIG

  # Remove tmp
  rm $KUBECONFIG.full.tmp
}

# env
export AWS_PROFILE=${aws_profile}
export AWS_DEFAULT_REGION=${aws_region}
export KUBECONFIG=./config-${cluster_name}

kube_config

if [ $SPIN_MANAGED = 'true' ]; then
kube_role
fi

# clean up env
unset AWS_PROFILE
unset AWS_DEFAULT_REGION
