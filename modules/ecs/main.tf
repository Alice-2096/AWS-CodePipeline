
resource "aws_ecs_cluster" "foo" {
  name = "my-cluster"

}

resource "aws_iam_role" "ecs_task_execution_role" {
  name        = "ecs_task_execution_role"
  description = "IAM role for ECS Task Execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "ecs_task_execution_policy"
  description = "Policy for ECS Task Execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_policy" "ec2-role" {
  name = "ec2-role"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeTags",
          "ecs:CreateCluster",
          "ecs:DeregisterContainerInstance",
          "ecs:DiscoverPollEndpoint",
          "ecs:Poll",
          "ecs:RegisterContainerInstance",
          "ecs:StartTelemetrySession",
          "ecs:UpdateContainerInstancesState",
          "ecs:Submit*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ecs:TagResource",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "ecs:CreateAction" : [
              "CreateCluster",
              "RegisterContainerInstance"
            ]
          }
        }
      }
    ]
  })
}
resource "aws_iam_policy" "secret_manager" {
  name        = "secret_manager_policy"
  description = "IAM policy for Secret Manager"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "secretsmanager:GetSecretValue",
                "ssm:GetParameters"
            ],
            "Resource": "*"
        }
    ]
  }
  EOT
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}
resource "aws_iam_role_policy_attachment" "ec2_task_execution_attachment" {
  policy_arn = aws_iam_policy.ec2-role.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}
resource "aws_iam_role_policy_attachment" "secret_manager_attachment" {
  policy_arn = aws_iam_policy.secret_manager.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_ecs_task_definition" "foo" {
  family                   = "my-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "my-app"
      image = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.project_name}:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      logConfiguration = {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "nyu-vip-container",
          "awslogs-region" : "us-east-1",
          "awslogs-create-group" : "true",
          "awslogs-stream-prefix" : "nyu-vip"
        }
      }
    }
  ])
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow traffic to ECS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.alb_security_group_id] // Allow incoming HTTP traffic from ALB only 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "foo" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.foo.arn
  desired_count   = 1
  depends_on      = [aws_iam_role.ecs_task_execution_role]
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "test-container"
    container_port   = 3000
  }
}
