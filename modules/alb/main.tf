
module "acm_alb" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "~> v2.0"
  domain_name = var.public_alb_domain
  zone_id     = data.aws_route53_zone.this.zone_id
}

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
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
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


module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 5.0"
  name               = "$nyu-vip-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb.id]

  https_listeners = [
    {
      "certificate_arn" = module.acm_alb.this_acm_certificate_arn
      "port"            = 443
    },
    {
      "certificate_arn" = module.acm_alb.this_acm_certificate_arn
      "port"            = 80
    },
  ]

  target_groups = [
    {
      name             = "nyu-default-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
    }
  ]
}
