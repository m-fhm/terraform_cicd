provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = "us-east-1"
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

resource "aws_instance" "prefect_triggers" {
    ami           = "ami-055744c75048d8296"
    instance_type = "t2.micro"
   
    tags = {
      Name = "prefect_triggers"
    }
    key_name= "prefect"
    vpc_security_group_ids = [aws_security_group.main.id]

  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote provisioner >> hello.txt",
    ]
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("C:\\Users\\hp\\Desktop\\keys\\prefect_triggers")
      timeout     = "4m"
   }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "prefect"
  public_key = file("C:\\Users\\hp\\Desktop\\keys\\prefect_triggers.pub")
}

output "ssh_connection_string" {
  value = format("ssh -i prefect_triggers ubuntu@ec2-%s.compute-1.amazonaws.com", replace(aws_instance.prefect_triggers.public_ip, ".", "-"))
}





