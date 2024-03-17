variable "subnets" {}
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}
variable "ecr_repo_name" {}
variable "repo_url" {}
variable "vpc_id" {
  type = string
}
variable "target_group_arn" {}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

