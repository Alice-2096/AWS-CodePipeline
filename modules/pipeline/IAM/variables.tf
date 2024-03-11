variable "create_new_role" {
  default = false
}
variable "codepipeline_iam_role_name" {
  description = "ARN of the codepipeline IAM role"
  type        = string
  default     = "nyu-codepipeline-iam-role"
}
variable "environment" {
  default = "dev"
}
variable "github_repo_name" {}
variable "github_repo_owner" {}
variable "aws_region" {}
variable "image_repo_name" {}
variable "image_tag" {}
variable "project_name" {
  description = "Unique name for this project"
  type        = string
}
variable "s3_bucket_arn" {}
variable "kms_key_arn" {

}
variable "codestar_connection_arn" {

}
