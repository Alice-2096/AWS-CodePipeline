
terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}

module "kms" {
  source = "./kms"
}

module "s3" {
  source       = "./s3"
  project_name = local.project_name
  kms_key_arn  = module.kms.kms_key_arn
}

# connection to GitHub 
resource "aws_codestarconnections_connection" "nyu-vip-connection" {
  name          = "${local.project_name}-connection"
  provider_type = "GitHub"
}

module "IAM" {
  depends_on                 = [module.s3, module.kms]
  source                     = "./IAM"
  create_new_role            = var.create_new_role
  codepipeline_iam_role_name = var.codepipeline_iam_role_name
  environment                = var.environment
  aws_region                 = var.aws_region
  project_name               = local.project_name
  s3_bucket_arn              = module.s3.bucket_arn
  s3_bucket_id               = module.s3.bucket_id
  kms_key_arn                = module.kms.kms_key_arn
  codestar_connection_arn    = aws_codestarconnections_connection.nyu-vip-connection.arn
}

module "codebuild" {
  source                              = "./CodeBuild"
  project_name                        = local.project_name
  kms_key_arn                         = module.kms.kms_key_arn
  role_arn                            = module.IAM.iam_role_arn
  builder_compute_type                = "BUILD_GENERAL1_SMALL"
  builder_type                        = "LINUX_CONTAINER"
  builder_image                       = "aws/codebuild/nodejs:14.0"
  builder_image_pull_credentials_type = "CODEBUILD"
}

module "codepipeline" {
  depends_on = [module.codebuild, module.s3, module.IAM]
  source     = "./CodePipeline"

  project_name      = local.project_name
  github_branch     = var.github_branch
  github_repo_name  = var.github_repo_name
  github_repo_owner = var.github_repo_owner
  s3_bucket_name    = module.s3.s3_bucket_name
  kms_key_arn       = module.kms.kms_key_arn
  role_arn          = module.IAM.iam_role_arn
  connection_arn    = aws_codestarconnections_connection.nyu-vip-connection.arn
}

