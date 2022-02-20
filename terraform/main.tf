provider "aws" {
    region = "eu-west-3"
}

data "aws_ami" "app_ami" {
  most_recent = true
  owners = ["amazon"]
  
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "myec2" {
    ami = "ami-0a3356555a1e3a8ef"  #data.aws_ami.app_ami.id
    instance_type = var.instance_type
    key_name = "devops-thomas"
    tags = var.aws_common_tag
    security_groups = [aws_security_group.allow_http_https_ssh.name]
    root_block_device {
      delete_on_termination = true 
      volume_size = 16
    }
    provisioner "remote-exec" {
        inline = [
          "sudo systemctl start nginx"
        ]
        connection {
          type = "ssh"
          user = "ubuntu"
          private_key = file("./devops-thomas.pem")
          host = self.public_ip
        }

    }
}

resource "aws_security_group" "allow_http_https_ssh" {
    name = "thomas-sg"
    description = "Allow http and https inbound traffic"

    ingress {
        description = "TLS from VPC"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }  
    ingress {
        description = "http from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "ssh from VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_eip" "lb" {
    instance = aws_instance.myec2.id
    vpc = true
    provisioner "local-exec" {
      command = "echo PUBLIC IP: ${aws_eip.lb.public_ip} > infos_ec2.txt; echo ID: ${aws_instance.myec2.id} >> infos_ec2.txt; echo AZ: ${aws_instance.myec2.availability_zone} >> infos_ec2.txt;"
    }
}
