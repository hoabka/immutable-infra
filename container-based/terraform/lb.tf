/*
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
*/
