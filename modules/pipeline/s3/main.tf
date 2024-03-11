
#Artifact bucket 
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${var.project_name}-codepipeline-bucket"
  force_destroy = true
}

# access control
resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_access" {
  bucket                  = aws_s3_bucket.codepipeline_bucket.id
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}
resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

# enable versioning and encryption 
resource "aws_s3_bucket_versioning" "codepipeline_bucket_versioning" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_encryption" {
  bucket = aws_s3_bucket.codepipeline_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# IAM roles and policies 
data "aws_iam_policy_document" "bucket_policy_doc_codepipeline_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.codepipeline_role_arn]
    }

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:ReplicateObject",
      "s3:PutObject",
      "s3:RestoreObject",
      "s3:PutObjectVersionTagging",
      "s3:PutObjectTagging",
      "s3:PutObjectAcl"
    ]

    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "bucket_policy_codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy_doc_codepipeline_bucket.json
}
