output "alb-dns-name" {
  value = aws_lb.webapp-alb.dns_name
}

output "private-instance-ids" {
  value = aws_instance.nginx-webapp[*].id
}

output "private-instance-ips" {
  value = aws_instance.nginx-webapp[*].private_ip
}
