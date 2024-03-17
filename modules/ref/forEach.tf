provider "aws" {
  region = "us-east-2"

}

resource "aws_instance" "web" {
  ami = "ami-0e83be366243f524a"
  for_each = { #  a map, each entry is a unique instance config
    prod = "t2.medium"
    dev  = "t2.micro"
  }
  instance_type = each.value # each is an entry in the map
  tags = {
    Name = "Test ${each.key}"
  }
}

output "instance" {
  value = aws_instance.web[*]
  # value = aws_instance.web["prod"] # to get specific instance
}
