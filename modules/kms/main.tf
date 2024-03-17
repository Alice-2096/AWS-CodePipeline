resource "aws_kms_key" "encryption_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    Name = "codepipeline-kms-key"
  }
}


