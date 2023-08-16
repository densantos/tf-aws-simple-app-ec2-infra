resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = <<EOF
#!/bin/bash
        
sudo apt-get update -y
sudo apt install nodejs npm -y
sudo apt-get install nginx -y
sudo apt-get install git

EOF
 
network_interface {
    network_interface_id = aws_network_interface.nic.id
    device_index         = 0
}

tags = {
    Name = var.name
    }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
