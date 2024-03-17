/*
using providers to work with multiple regions or cloud providers
*/

provider "aws" { # takes precedence by default 
  region = "us-east-2"

}

# specify another provider with alias 
provider "aws" {
  alias  = "east-1"
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0e83be366243f524a"
  instance_type = "t2.micro"
  tags = {
    Name = "foo"
  }
}

resource "aws_instance" "web-us-east-1" {
  provider      = aws.east-1 # specify the provider by alias 
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  tags = {
    Name = "east-1-foo"
  }
}
