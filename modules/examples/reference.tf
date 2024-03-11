provider "aws" {
  region = "us-east-2"

}

/*
the order of resource declaration does not matter, since terraform will create a dependency graph and figure out the order of creation

But for readability, declare the resources in the order of dependency
*/
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "mainVpc"
  }
}

resource "aws_subnet" "web" {
  vpc_id = aws_vpc.main.id
  /*
  vpc_id is the id of the vpc resource we created above
  we can reference it by 
      resourceName.resourceName.attributeName
  */
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "web-subnet"
  }
}


resource "aws_instance" "firstInstance" {
  ami           = "ami-0e83be366243f524a"
  instance_type = "t2.micro"
  tags = {
    Name       = "aliceEC2"
    anotherTag = "anotherValue"
  }
  subnet_id = aws_subnet.web.id
  /*
  again, here we launch ec2 instance in the subnet we created above by referencing its id 
  */
}

