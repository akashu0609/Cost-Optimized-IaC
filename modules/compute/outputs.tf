output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.app_asg.name
}
