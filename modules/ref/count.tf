provider "aws" {
  region = "us-east-2"

}

resource "aws_instance" "web" {
  ami           = "ami-0e83be366243f524a"
  instance_type = "t2.micro"
  count         = 2 # launch 2 instances, can be dynamically set by variables
  # note: if count = 0, then we will not create any instances 

  tags = {
    Name = "Test ${count.index}"
  }
}


output "instance" {
  value = aws_instance.web[*].public_ip # output the public IP of all instances in the list 

  # value = [for instance in aws_instance.web :
  # instance.public_ip] 
}
