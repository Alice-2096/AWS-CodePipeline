variable "project_name" {

}
variable "role_arn" {
  description = "Codepipeline IAM role arn. "
  type        = string
  default     = ""
}

variable "kms_key_arn" {

}
variable "build_project_source" {
  description = "Information about the build output artifact location"
  type        = string
  default     = "CODEPIPELINE"
}
variable "s3_bucket_name" {
  description = "Name of the S3 bucket used to store the deployment artifacts"
  type        = string
}
variable "builder_compute_type" {

}
variable "builder_image" {

}
variable "builder_type" {

}
variable "builder_image_pull_credentials_type" {

}
