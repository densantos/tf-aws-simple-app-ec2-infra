# VPC 
resource "aws_vpc" "vpc" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "vpc-main"
  }
}
# IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw_main"
  }
}
# SUBNET
resource "aws_subnet" "subnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "10.100.10.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "snet-public-app"
  }

}
# SUBNET ROUTE TABLE 
resource "aws_route_table" "subnet_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# SUBNET ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "attach_route" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.subnet_route.id
}

# EC2 NIC
resource "aws_network_interface" "nic" {
  subnet_id       = aws_subnet.subnet.id
  private_ips     = ["10.100.10.100"]
  security_groups = [aws_security_group.sg.id]
}

# PUBLIC IP
resource "aws_eip" "app_eip" {
  vpc                       = true
  instance                  = aws_instance.ec2.id
  associate_with_private_ip = "10.100.10.100"
  depends_on = [
    aws_instance.ec2
  ]
}

# EC2 SG
resource "aws_security_group" "sg" {
  name        = "ssh_ingress_security_group"
  description = "Allow SSH access from anywhere"
  vpc_id      = aws_vpc.vpc.id

  # Allow SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow HTTP from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}