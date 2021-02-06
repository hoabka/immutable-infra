#!/bin/bash -xe

SPIN_MANAGED=true
NAMESPACE=us-west-2
CONTEXT=eks

### update kubeconfig
function kube_config () {
  aws eks update-kubeconfig --name eks --profile svmc --no-verify-ssl
  # change the context of kubernetes cluster
  kubectl config use-context arn:aws:eks:us-west-2:633834615594:cluster/demo-eks-cluster
    # register worker nodes to master
  cat  << EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::633834615594:role/eks-node
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::633834615594:role/eks-manage-role
      username: arn:aws:eks:us-west-2:633834615594:cluster/demo-eks-cluster
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

  kubectl config set-credentials eks-sa --token $TOKEN
  kubectl config set-context $CONTEXT --cluster=arn:aws:eks:us-west-2:633834615594:cluster/demo-eks-cluster --user=eks-sa --namespace=$NAMESPACE
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
export AWS_PROFILE=svmc
export AWS_DEFAULT_REGION=us-west-2
export KUBECONFIG=./config-eks

kube_config

if [ $SPIN_MANAGED = 'true' ]; then
kube_role
fi

# clean up env
unset AWS_PROFILE
unset AWS_DEFAULT_REGION
