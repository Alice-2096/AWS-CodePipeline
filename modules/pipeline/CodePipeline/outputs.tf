output "arn" {
  value       = aws_codepipeline.terraform_pipeline.arn
  description = "The arn of the CodePipeline"
}
output "id" {
  value       = aws_codepipeline.terraform_pipeline.id
  description = "The id of the CodePipeline"
}

output "name" {
  value       = aws_codepipeline.terraform_pipeline.name
  description = "The name of the CodePipeline"
}
output "codestar_connection_arn" {
  value       = aws_codepipeline.terraform_pipeline.codestar_connection_arn
  description = "The ARN of the CodeStar connection"
}
