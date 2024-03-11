data "aws_ecr_repository" "my_ecr_repository" {
  name = "nyu-vip"
}

data "aws_ecr_image" "latest_image" {
  repository_name = data.aws_ecr_repository.my_ecr_repository.name
  most_recent     = true
}
