output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "appserver_private_ip" {
  value = [ for server in aws_instance.appserver: server.private_ip]
}

output "primary_db_endpoint" {
  value = aws_db_instance.primary.endpoint
}
