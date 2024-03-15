variable "github_branch" {}
variable "github_repo_name" {}
variable "github_repo_owner" {}
variable "aws_region" {}
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
