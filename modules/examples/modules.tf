provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

module "alices_webserver" {
  source         = "./modules/webserver" # path to the module or an url to the remote module in registry 
  vpc_id         = aws_vpc.main.id
  cidr_block     = "10.0.0.0/16"
  ami            = "ami-0c55b159cbfafe1f0"
  instance_type  = "t2.micro"
  webserver_name = "alices_webserver"
}

resource "aws_elb" "main" {
  instances = module.alices_webserver.webserver.id # reference to the module's output 
  name      = "alices_webserver"
  subnets   = [aws_subnet.web.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

# can also do for_each to create multiple instances of the module 
module "alices_webserver_west" {
  source = "./modules/webserver"
  providers = {
    aws = aws.west
  }
  vpc_id         = aws_vpc.main.id
  cidr_block     = "10.0.0.0/16"
  ami            = "ami-0c55b159cbfafe1f0"
  instance_type  = "t2.micro"
  webserver_name = "alices_webserver"
}










