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
  source = "./modules/kms"
}

module "s3" {
  source       = "./modules/s3"
  project_name = local.project_name
  kms_key_arn  = module.kms.kms_key_arn
}

# connection to GitHub -- NOTE : This is a manual step. You need to create a connection to GitHub in the AWS console
resource "aws_codestarconnections_connection" "nyu-vip-connection" {
  name          = "${local.project_name}-github-connection"
  provider_type = "GitHub"
}

module "IAM" {
  depends_on                 = [module.s3, module.kms]
  source                     = "./modules/IAM"
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
  source                              = "./modules/CodeBuild"
  project_name                        = local.project_name
  kms_key_arn                         = module.kms.kms_key_arn
  role_arn                            = module.IAM.iam_role_arn
  builder_compute_type                = "BUILD_GENERAL1_SMALL"
  builder_type                        = "LINUX_CONTAINER"
  builder_image                       = "aws/codebuild/standard:4.0"
  builder_image_pull_credentials_type = "CODEBUILD"
  ecr_repo_url                        = var.ecr_repo_url
  ecr_repo_name                       = var.ecr_repo_name
  aws_region                          = var.aws_region
  container_name                      = var.container_name
}

////////////////////////// ECS //////////////////////////

module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  depends_on     = [module.vpc]
}

module "ecs" {
  source                = "./modules/ecs"
  subnets               = module.vpc.private_subnets
  vpc_id                = module.vpc.vpc_id
  alb_security_group_id = module.alb.security_group_id
  target_group_arn      = module.alb.target_group_arn
  depends_on            = [module.alb]
  ecr_repo_name         = var.ecr_repo_name
  repo_url              = var.ecr_repo_url
  project_name          = local.project_name
  aws_region            = var.aws_region
  container_name        = var.container_name
}

module "codedeploy" {
  source                = "./modules/codedeploy"
  depends_on            = [module.ecs]
  project_name          = local.project_name
  role_arn              = module.IAM.iam_role_arn
  ecs_service_name      = module.ecs.ecs_service_name
  ecs_cluster_name      = module.ecs.ecs_cluster_name
  aws_lb_listener_arn   = module.alb.listener_arn
  alb_target_group_name = module.alb.target_group_name
}

////////////////////////// CodePipeline ////////////////////////// 

module "codepipeline" {
  depends_on = [module.codebuild, module.s3, module.IAM, module.codedeploy]
  source     = "./modules/CodePipeline"

  project_name                     = local.project_name
  github_branch                    = var.github_branch
  github_repo_name                 = var.github_repo_name
  github_repo_owner                = var.github_repo_owner
  s3_bucket_name                   = module.s3.s3_bucket_name
  kms_key_arn                      = module.kms.kms_key_arn
  role_arn                         = module.IAM.iam_role_arn
  connection_arn                   = aws_codestarconnections_connection.nyu-vip-connection.arn
  cluster_name                     = module.ecs.ecs_cluster_name
  service_name                     = module.ecs.ecs_service_name
  codedeploy_app_name              = module.codedeploy.codedeploy_app_name
  codedeploy_deployment_group_name = module.codedeploy.codedeploy_deployment_group_name
}
