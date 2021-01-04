output "lb_dns" {
  value = aws_lb.web-lb.dns_name
  description = "Web LB domain name"
}