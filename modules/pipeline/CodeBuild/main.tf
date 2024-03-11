resource "aws_codebuild_project" "terraform_codebuild_project" {
  name           = var.project_name
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
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
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


# resource "aws_iam_role" "codebuild_role" {
#   name               = "awsecsdemo_springboot_codebuild_role-${var.image_repo_name}"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "codebuild.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": "TrustPolicyStatementThatAllowsEC2ServiceToAssumeTheAttachedRole"
#     }
#   ]
# }
# EOF
# }
# resource "aws_iam_role_policy" "codebuild_policy" {
#   name   = "awsecsdemo_springboot_codebuild_policy-${var.image_repo_name}"
#   role   = aws_iam_role.codebuild_role.id
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": "arn:aws:logs:*:*:*",
#       "Effect": "Allow"
#     },
#     {
#       "Action": [
#         "s3:GetObject",
#         "s3:GetObjectVersion",
#         "s3:GetBucketVersioning",
#         "s3:PutObjectVersionTagging",
#         "s3:PutObjectLegalHold",
#         "s3:GetBucketVersioning",
#         "s3:PutObject",
#         "s3:PutObjectRetention",
#         "s3:PutObjectVersionAcl",
#         "s3:PutObjectTagging",
#         "s3:PutObjectAcl"
#       ],
#       "Resource": [
#         "arn:aws:s3:::${aws_s3_bucket.codepipeline_bucket.bucket}",
#         "arn:aws:s3:::${aws_s3_bucket.codepipeline_bucket.bucket}/*"
#       ],
#       "Effect": "Allow"
#     },
#     {
#       "Action": [
#         "ecr:BatchCheckLayerAvailability",
#         "ecr:CompleteLayerUpload",
#         "ecr:GetAuthorizationToken",
#         "ecr:InitiateLayerUpload",
#         "ecr:PutImage",
#         "ecr:UploadLayerPart"
#       ],
#       "Resource": [
#         "*"
#       ],
#         "Effect": "Allow"
#     },
#     {
#       "Action": [
#         "ecs:UpdateService",
#         "ecs:ListTaskDefinitions",
#         "ecs:DescribeTaskDefinition",
#         "ecs:RegisterTaskDefinition",
#         "ecs:DeregisterTaskDefinition",
#         "ecs:DescribeServices",
#         "ecs:DescribeClusters",
#         "ecs:ListClusters",
#         "ecs:ListServices",
#         "iam:GetRole",
#         "iam:PassRole"
#       ],
#       "Resource": [
#         "*"
#       ],
#         "Effect": "Allow"
#     }
#   ]
# }
# EOF
# }
