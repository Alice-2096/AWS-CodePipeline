variable "subnets" {}

variable "aws_account_id" {
  type    = string
  default = "713215096865"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "nyu-vip"
}

variable "alb_security_group_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "target_group_arn" {

}
