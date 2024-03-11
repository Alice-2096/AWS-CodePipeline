provider "aws" { # takes precedence by default 
  region = "us-east-2"

}


resource "aws_instance" "web" {
  ami           = "ami-0e83be366243f524a"
  instance_type = "t2.micro"
  tags = {
    Name = "foo"
  }


  connection { # tell terraform how to connect to the instance by default 
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/USER/.ssh/id_rsa") # path to the private key to connect to the instance
    host        = self.public_ip
  }

  # will only run the first time the instance is created 
  provisioner "local-exec" { # execute the following commands on local machine (wherever we call terraform apply)
    command = "echo ${aws_instance.web.public_ip} > ip_address.txt"
    # command = "echo ${self.public_ip} > ip_address.txt" 
  }

  provisioner "file" {
    content     = "hello world"
    destination = "/home/tmp.txt" # add the content/source into the file in the instance/remote machine  
  }

  provisioner "remote-exec" { # execute a script on a remote machine 
    # when = destroy            # only run when the instance is destroyed 
    # if not specify when, it will run every time the instance is created 

    on_failure = continue # continue even if the script fails

    inline = [
      "sudo yum install -y nginx", # any type of bash command -- e.g., create a file, install a package, etc. 
      "sudo systemctl start nginx"
    ]
  }
}




