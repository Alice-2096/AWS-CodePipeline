variable "codepipeline_iam_role_name" {
  description = "ARN of the codepipeline IAM role"
  type        = string
  default     = "nyu-codepipeline-iam-role"
}
variable "environment" {
  default = "dev"
}
variable "aws_region" {}
variable "project_name" {
  description = "Unique name for this project"
  type        = string
}
variable "s3_bucket_arn" {}
variable "s3_bucket_id" {}
variable "kms_key_arn" {}
variable "codestar_connection_arn" {}
