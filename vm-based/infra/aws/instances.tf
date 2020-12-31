resource "aws_instance" "bastion" {
  ami               = data.aws_ami.bastion.id
  instance_type     = var.bastion_instance_type
  availability_zone = local.target_azs[0]
  subnet_id         = aws_subnet.public[0].id
  key_name          = aws_key_pair.bastion.key_name

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

resource "aws_instance" "web" {
  count             = var.number_web_instances
  ami               = data.aws_ami.web.id
  instance_type     = var.web_instance_type
  availability_zone = local.target_azs[count.index % var.number_private_subnets]
  subnet_id         = aws_subnet.private[count.index % var.number_private_subnets].id
  key_name          = aws_key_pair.web.key_name
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.web.id,
    aws_security_group.admin.id]

  tags = {
    Name = "web-${format("%02d", count.index + 1)}"
  }
}

resource "aws_instance" "app" {
  count             = var.number_app_instances
  ami               = data.aws_ami.app.id
  instance_type     = var.app_instance_type
  availability_zone = local.target_azs[count.index % var.number_private_subnets]
  subnet_id         = aws_subnet.private[count.index % var.number_private_subnets].id
  key_name          = aws_key_pair.app.key_name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = true
  }

  vpc_security_group_ids  = [aws_security_group.app.id,
  aws_security_group.admin.id]

  tags = {
    Name = "app-${format("%02d", count.index + 1)}"
  }
}

