provider "aws" { # takes precedence by default 
  region = "us-east-2"

}


resource "aws_instance" "web" {
  ami           = "ami-0e83be366243f524a"
  instance_type = "t2.micro"
  tags = {
    Name = "foo"
  }

  lifecycle {
    create_before_destroy = true # create new instance before destroying old one 
    prevent_destroy       = true # prevent accidental deletion 
    ignore_changes        = [tags]
  }
}

locals {
  ingress_rules = [{
    port        = 443
    description = "port 443"
    },
    {
      port        = 80
      description = "port 80"
  }]
}
resource "aws_security_group" "main" {
  name = "tutorial-sg"

  #dynamic block 
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {                          # the data for the block you are creating dynamically 
      from_port   = ingress.value.port # the name of the block is the iterator by default unless you rename it 
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}


