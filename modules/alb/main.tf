
resource "aws_security_group" "alb" {
  name        = "nyu-alb"
  description = "Allow HTTPS inbound traffc"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}

resource "aws_alb" "application_load_balancer" {
  name               = "nyu-vip-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "target_group" {
  count = 2 # used for blue-green deployment
  name  = "nyu-vip-target-group-${count.index}"


  port        = 3000 # container port 
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/"
    protocol = "HTTP"
    port     = "3000"
    interval = 300
  }
}

#Defines an HTTP Listener for the ALB
resource "aws_lb_listener" "listener" {
  depends_on        = [aws_lb_target_group.target_group]
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[0].arn
  }
}

