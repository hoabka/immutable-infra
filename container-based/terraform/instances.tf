resource "aws_instance" "bastion" {
  ami               = data.aws_ami.bastion.id
  instance_type     = var.bastion_instance_type
  availability_zone = local.target_azs[0]
  subnet_id         = aws_subnet.public[0].id
  key_name          = aws_key_pair.bastion.key_name
  iam_instance_profile = module.eks.eks_manage_instance_profile

  vpc_security_group_ids = [aws_security_group.bastion.id]


  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = true
  }

  tags = {
    Name = "bastion-01"
  }
}

resource "aws_eip_association" "bastion" {
  allocation_id = aws_eip.bastion.id
  instance_id   = aws_instance.bastion.id
}
