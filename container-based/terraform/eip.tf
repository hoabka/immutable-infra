resource "aws_eip" "nat-gw" {
  vpc        = true
}

resource "aws_eip" "bastion" {
  vpc = true
}