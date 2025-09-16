variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "jenkins_security_group_id" {
  description = "Security Group ID for the EC2 instance"
  type        = string
}

variable "dev_server_security_group_id" {
  description = "Security Group ID for the EC2 instance"
  type        = string
}

variable "prod_server_security_group_id" {
  description = "Security Group ID for the EC2 instance"
  type        = string
}

variable "monitor_server_security_group_id" {
  description = "Security Group ID for the EC2 instance"
  type        = string
}
variable "iam_instance_profile" {
  description = "IAM Instance Profile name"
  type        = string
}

variable "key_name" {
  type        = string
  default     = "server-key"
}

variable "public_key_path" {
  type        = string
   default    = "public key path"
}

variable "ami" {
  type        = string
  default     = "ami-02d26659fd82cf299"
}

variable "instance_type"{
  type        = string
  default     = "t2.micro"
}

variable "user_data_path" {
  type        = string
  default     = "./ec2/userdata.sh"
}

variable "user_data_path_docker" {
  type        = string
  default     = "./ec2/docker-setup.sh"
}

variable "user_data_path_prometheus" {
  type        = string
  default     = "./ec2/monitor-setup.sh"
}
