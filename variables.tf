variable "github_branch" {
  description = "Branch of the GitHub repository"
  type        = string
  default     = "main"
}
variable "github_repo_name" {
  description = "Name of the GitHub repository"
  type        = string
  default     = "NYU-AL"
}
variable "github_repo_owner" {
  description = "Owner of the GitHub repository"
  type        = string
  default     = "Alice-2096"
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"

}
variable "codepipeline_iam_role_name" {
  description = "ARN of the codepipeline IAM role"
  type        = string
  default     = "nyu-codepipeline-iam-role"
}
variable "environment" {
  default = "dev"
}

variable "ecr_repo_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "ecr_repo_name" {
  default = "nyu-vip"
}
variable "container_name" {
  default = "nyu-vip-container"
}
