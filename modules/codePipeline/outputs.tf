output "arn" {
  value       = aws_codepipeline.codepipeline.arn
  description = "The arn of the CodePipeline"
}
output "id" {
  value       = aws_codepipeline.codepipeline.id
  description = "The id of the CodePipeline"
}

output "name" {
  value       = aws_codepipeline.codepipeline.name
  description = "The name of the CodePipeline"
}

