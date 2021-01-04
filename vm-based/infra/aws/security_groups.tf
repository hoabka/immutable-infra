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

resource "aws_security_group_rule" "lb-web-access" {
  from_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.lb-external.id
  to_port = 80
  type = "egress"
  source_security_group_id = aws_security_group.web.id
  description = "Allow access to web"
}

resource "aws_security_group" "web" {
  name = "sg_web"
  vpc_id = aws_vpc.demo-vpc.id
  description = "Web security groups"
}

resource "aws_security_group_rule" "web-allow-lb-access" {
  from_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.web.id
  to_port = 80
  type = "ingress"
  source_security_group_id = aws_security_group.lb-external.id
  description = "allow http from lb"
}

resource "aws_security_group_rule" "web-access-to-app" {
  from_port = 8080
  protocol = "TCP"
  security_group_id = aws_security_group.web.id
  to_port = 8080
  type = "egress"
  source_security_group_id = aws_security_group.app.id
  description = "allow http to app"
}

resource "aws_security_group" "app" {
  name = "sg_app"
  vpc_id = aws_vpc.demo-vpc.id
  description = "APP security groups"
}

resource "aws_security_group_rule" "app-allow-web-access" {
  from_port = 8080
  protocol = "TCP"
  security_group_id = aws_security_group.app.id
  to_port = 8080
  type = "ingress"
  source_security_group_id = aws_security_group.web.id
  description = "Allow access from Web"
}

