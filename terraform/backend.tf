terraform {
  backend "s3" {
    bucket         = "terraform-state-09092025"
    key            = "env/servers/terraform.tfstate"
    region         = "ap-south-1"
    # dynamodb_table = "terraform-lock-table"  # Optional for state locking
    encrypt        = true
  }
}