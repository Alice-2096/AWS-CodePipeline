variable "project_name" {}

variable "kms_key_arn" {}
variable "role_arn" {}
variable "build_project_source" {
  description = "Information about the build output artifact location"
  type        = string
  default     = "CODEPIPELINE"
}
variable "builder_compute_type" {

}
variable "builder_image" {

}
variable "builder_type" {

}
variable "builder_image_pull_credentials_type" {

}
