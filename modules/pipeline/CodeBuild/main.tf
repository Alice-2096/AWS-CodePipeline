data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_codebuild_project" "nyu_vip_codebuild_project" {
  name           = "${var.project_name}-codebuild"
  service_role   = var.role_arn
  encryption_key = var.kms_key_arn
  tags = {
    Name = "${var.project_name}-codebuild"

  }

  artifacts {
    type = var.build_project_source
  }

  environment {
    compute_type                = var.builder_compute_type
    image                       = var.builder_image
    type                        = var.builder_type
    privileged_mode             = true
    image_pull_credentials_type = var.builder_image_pull_credentials_type

    environment_variable {
      name  = "REPO_URL"
      value = "${var.ecr_repo_url}/${var.ecr_repo_name}"
    }
    environment_variable {
      name  = "PUSH_TO_ECR_COMMAND"
      value = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.ecr_repo_url}"
    }
    environment_variable {
      name = "CONTAINER_NAME"
      value = "${var.container_name}"
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type      = var.build_project_source
    buildspec = "buildspec.yml"
  }
}

//////////////// IAM policy for codebuild ///////////////////////


# data "aws_iam_policy_document" "codebuild_policy" {
#   statement {
#     sid = "ECSBuildAndPushPolicy"

#     actions = [
#       "ecr:GetAuthorizationToken",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload",
#       "ecr:PutImage"
#     ]

#     resources = [
#       "*"
#     ]
#   }
# }

# resource "aws_iam_policy" "codebuild_policy" {
#   name        = "CodeBuildECSAndECRPolicy"
#   description = "Policy to allow CodeBuild to build image on ECS and push to ECR"
#   policy      = data.aws_iam_policy_document.codebuild_policy.json
# }

# resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
#   role       = aws_iam_role.codebuild_role.name
#   policy_arn = aws_iam_policy.codebuild_policy.arn
# }
