resource "aws_lb" "web-lb" {
  load_balancer_type = "application"
  name = "web-lb"
  dynamic "subnet_mapping" {
    for_each = [for i in range(length(aws_subnet.public)) : {
      subnet_id = aws_subnet.public[i].id
      }
    ]
    content {
      subnet_id = subnet_mapping.value.subnet_id
    }
  }

  security_groups = [aws_security_group.lb-external.id]

  tags = {
    Name = "web-lb"
  }
}

resource "aws_lb_listener" "web-lb" {
  load_balancer_arn = aws_lb.web-lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo-vpc.id
}

resource "aws_lb_target_group_attachment" "web" {
  count            = var.number_web_instances
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web[count.index].id
}