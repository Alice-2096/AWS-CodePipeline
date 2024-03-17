terraform {
  backend "s3" { # store state file remotely in S3
    bucket = "terraform-remote-state-2024"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "webserver" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-example"
  }
}


