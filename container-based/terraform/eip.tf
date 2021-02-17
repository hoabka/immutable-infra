resource "aws_eip" "nat-gw" {
  vpc        = true
}