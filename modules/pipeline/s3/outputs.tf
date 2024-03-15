output "bucket_id" {
  value = aws_s3_bucket.codepipeline_bucket.id
}
output "bucket_arn" {
  value = aws_s3_bucket.codepipeline_bucket.arn
}
output "s3_bucket_name" {
  value = aws_s3_bucket.codepipeline_bucket.bucket
}
