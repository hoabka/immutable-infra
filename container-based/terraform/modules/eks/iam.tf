data "aws_region" "current" {
}
locals {
  is_china = substr(data.aws_region.current.name, 0, 2) == "cn" ? true : false
  arn_aws  = local.is_china ? "aws-cn" : "aws"
}

resource "aws_iam_role" "eks-master" {
  name="eks-cluster"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]

}
POLICY
}

resource "aws_iam_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:${local.arn_aws}:iam::aws:policy/AmazonEKSClusterPolicy"
  roles = [aws_iam_role.eks-master.name]
  name="cluster-AmazonEKSClusterPolicy"
}


resource "aws_iam_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:${local.arn_aws}:iam::aws:policy/AmazonEKSServicePolicy"
  roles = [aws_iam_role.eks-master.name]
  name = "cluster-AmazonEKSServicePolicy"
}


resource "aws_iam_role" "eks-node" {
  name = "eks-node"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com.cn"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
}
POLICY
}

resource "aws_iam_policy_attachment" "eks-node-AmazonEKSServicePolicy" {
  policy_arn = "arn:${local.arn_aws}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  roles = [aws_iam_role.eks-node.name]
  name="node-AmazonEKSServicePolicy"
}

resource "aws_iam_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:${local.arn_aws}:iam::aws:policy/AmazonEKS_CNI_Policy"
  roles = [aws_iam_role.eks-node.name]
  name="node-AmazonEKS_CNI_Policy"
}

resource "aws_iam_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:${local.arn_aws}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles = [aws_iam_role.eks-node.name]
  name="node-node-AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "node" {
  name = "eks-node"
  role = aws_iam_role.eks-node.name
}

resource "aws_iam_role" "eks-manage-role" {
  name = "eks-manage-role"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com.cn"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
}
POLICY
}

resource "aws_iam_policy" "eks-manage-role" {
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1607934547971",
      "Action": "eks:DescribeCluster",
      "Effect": "Allow",
      "Resource": "${aws_eks_cluster.eks-cluster.arn}"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "eks-manage-role" {
  name       = "eks-manage-role-policy-attachment"
  policy_arn = aws_iam_policy.eks-manage-role.arn
  roles = [aws_iam_role.eks-manage-role.name]
}

resource "aws_iam_instance_profile" "eks-manage-role" {
  name = "eks-manage-role"
  role = aws_iam_role.eks-manage-role.name
}
