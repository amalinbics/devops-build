resource "aws_key_pair" "server_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.jenkins_security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true
  key_name                    = aws_key_pair.server_key.key_name
  user_data                   = file(var.user_data_path)
  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_instance" "dev-server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.dev_server_security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true
  key_name                    = aws_key_pair.server_key.key_name
  user_data                   = file(var.user_data_path_docker)
  tags = {
    Name = "Dev-Server"
  }
}

resource "aws_instance" "prod-server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.prod_server_security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true
  key_name                    = aws_key_pair.server_key.key_name
  user_data                   = file(var.user_data_path_docker)
  tags = {
    Name = "prod-Server"
  }
}


resource "aws_instance" "monitor-server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.monitor_server_security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true
  key_name                    = aws_key_pair.server_key.key_name
  user_data                   = file(var.user_data_path_prometheus)
  tags = {
    Name = "monitor-Server"
  }
}
