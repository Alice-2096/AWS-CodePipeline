# To be used only in case of an Existing Repository
data "aws_iam_role" "existing_codepipeline_role" {
  count = var.create_new_role ? 0 : 1
  name  = var.codepipeline_iam_role_name #fetch the existing role by role name
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}
