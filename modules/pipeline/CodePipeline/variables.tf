variable "github_branch" {}
variable "github_repo_name" {}
variable "github_repo_owner" {}
variable "image_repo_name" {}
variable "image_tag" {}
variable "project_name" {
  description = "Unique name for this project"
  type        = string
}
variable "s3_bucket_name" {
  description = "Name of the S3 bucket used to store the deployment artifacts"
  type        = string
}
variable "kms_key_arn" {

}
