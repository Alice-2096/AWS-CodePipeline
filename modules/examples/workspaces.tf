provider "aws" {
  region = "us-east-2"
}

locals {
  instance_name = "${terraform.workspace}-instance"
}
# resource "aws_instance" "webserver" {
#   ami           = var.ami
#   instance_type = var.instance_type
#   tags = {
#     name = local.instance_name
#   }
# }


