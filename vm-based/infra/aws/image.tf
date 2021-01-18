data "aws_ami" "bastion" {
  most_recent      = true
  filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 18.04 LTS*",]
  }

  filter {
    name   = "root-device-type"
    values = [
      "ebs",
    ]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "web" {
  most_recent = true
  filter {
    name   = "description"
    values = ["${var.project}-web*"]
  }

  owners   = ["self"]
}

data "aws_ami" "app" {
  most_recent = true
  filter {
    name   = "description"
    values = ["${var.project}-app*"]
  }
  owners   = ["self"]
}