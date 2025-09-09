output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "jenkins_security_group_id" {
  value = aws_security_group.jenkins_sg.id
}

output "dev_server_security_group_id" {
  value = aws_security_group.dev_server_sg.id
}

output "prod_server_security_group_id" {
  value = aws_security_group.prod_server_sg.id
}

output "monitor_server_security_group_id" {
  value = aws_security_group.monitor_server_sg.id
}