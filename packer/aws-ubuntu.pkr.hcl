packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "quantum-sandbox-V1.0.0"
  instance_type = "t2.micro"
  region        = "eu-west-3"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    environment_vars = [
        "FOO=hello world",
    ]
    inline = [
        "echo Installing Python",
        "sleep 30",
        "sudo apt-get update",
        "sudo apt-get install -y python3-pip",
        "sudo apt-get install -y nginx",
        "sudo apt-get install -y expect"
        "sudo pip3 install qiskit",
        "cd /tmp",
        "sudo curl -O https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh",
        "sudo bash Anaconda3-2021.11-Linux-x86_64.sh -b -p /opt/conda",
        "echo \\#Custom configurations >> ~/.bashrc", 
        "echo export PATH=/opt/conda/bin:$PATH >> ~/.bashrc",
    ]
  }

}
