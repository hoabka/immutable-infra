resource "aws_security_group" "bastion" {
  name = "sg_bastion"
  vpc_id = aws_vpc.demo-vpc.id
  description = "Bastion security group"
}

resource "aws_security_group_rule" "bastion-ssh" {
  from_port = 22
  protocol = "TCP"
  security_group_id = aws_security_group.bastion.id
  to_port = 22
  type = "ingress"
  cidr_blocks = [var.ssh_allow_cidr]
  description = "For allow ssh from outside"
}

resource "aws_security_group_rule" "admin-manage" {
  from_port = 22
  protocol = "TCP"
  security_group_id = aws_security_group.bastion.id
  to_port = 22
  type = "egress"
  source_security_group_id = aws_security_group.admin.id
  description = "For admin management"
}


resource "aws_security_group" "admin" {
  name = "sg_adm"
  vpc_id = aws_vpc.demo-vpc.id
  description = "Management security groups"
}

resource "aws_security_group_rule" "admin-in" {
  from_port = 22
  protocol = "TCP"
  security_group_id = aws_security_group.admin.id
  to_port = 22
  type = "ingress"
  source_security_group_id = aws_security_group.bastion.id
  description = "For ssh access from bastion"
}

resource "aws_security_group_rule" "admin-out" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.admin.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "All traffic outbound"
}


resource "aws_security_group" "lb-external" {
  name = "sg_alb"
  vpc_id = aws_vpc.demo-vpc.id
  description = "LB security groups"
}

resource "aws_security_group_rule" "lb-allow-http" {
  from_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.lb-external.id
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow access from external"
}

#For EKS master and nodes

resource "aws_security_group" "sg-eks-master" {
  name = "sg_eks_master"
  vpc_id = aws_vpc.demo-vpc.id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_eks_master"
  }
}

resource "aws_security_group" "sg-eks-node" {
  name = "sg_eks_node"
  vpc_id = aws_vpc.demo-vpc.id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_eks_node"
  }
}

resource "aws_security_group_rule" "sg-eks-master-ingress-https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.sg-eks-master.id
  to_port = 443
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"] #For demo purpose
  description = "Allow access to API master"
}

resource "aws_security_group_rule" "sg-eks-node-ingress-self" {
  description = "Allow nodes to communicate with each other"
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.sg-eks-node.id
  source_security_group_id = aws_security_group.sg-eks-node.id
  to_port = 65535
  type = "ingress"
}

resource "aws_security_group_rule" "sg-eks-node-ingress-cluster" {
  description = "Allow worker Kubeletes and pods to receive communication from the cluster control plane"
  from_port = 1025
  protocol = "tcp"
  security_group_id = aws_security_group.sg-eks-node.id
  source_security_group_id = aws_security_group.sg-eks-master.id
  to_port = 65535
  type = "ingress"
}

resource "aws_security_group_rule" "sg-eks-master-ingress-master-https" {
  description = "Allow pods to communicate with the cluster API server"
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.sg-eks-node.id
  source_security_group_id = aws_security_group.sg-eks-master.id
  to_port = 443
  type = "ingress"
}

resource "aws_security_group_rule" "sg-eks-master-ingress-master" {
  description = "Allow cluster control to receive communication from the worker Kubeletes"
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.sg-eks-master.id
  source_security_group_id = aws_security_group.sg-eks-node.id
  to_port = 443
  type = "ingress"
}
