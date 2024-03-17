variable "github_branch" {}
variable "github_repo_name" {}
variable "github_repo_owner" {}
variable "project_name" {
  description = "Unique name for this project"
  type        = string
}
variable "s3_bucket_name" {
  description = "Name of the S3 bucket used to store the deployment artifacts"
  type        = string
}
variable "kms_key_arn" {}
variable "role_arn" {
  description = "ARN of the IAM role to use for the CodePipeline project"
  type        = string
}
variable "connection_arn" {
  description = "ARN of the CodeStar connection"
  type        = string
}

variable "cluster_name" {}
variable "service_name" {}

variable "codedeploy_app_name" {
}
variable "codedeploy_deployment_group_name" {

}
