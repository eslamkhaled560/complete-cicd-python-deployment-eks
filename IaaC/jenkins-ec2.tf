provider "aws" {
    region = var.aws_region
}

resource "aws_vpc" "jenkins_vpc" {
    cidr_block = var.jenkins_vpc_cidr_block
    tags = { Name = "jenkins-vpc" }
}

resource "aws_internet_gateway" "jenkins_igw" {
    vpc_id = aws_vpc.jenkins_vpc.id
    tags = { Name = "jenkins-igw" }
}

resource "aws_subnet" "subnet_jenkins" {
  vpc_id     = aws_vpc.jenkins_vpc.id
  cidr_block = var.jenkins_subnet
  availability_zone = var.jenkins_subnet_az
  tags = { Name = "subnet-jenkins" }
}

resource "aws_route_table" "rt_jenkins" {
  vpc_id = aws_vpc.jenkins_vpc.id
  route {
    cidr_block = var.jenkins_cidr_block_rt
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }
  tags = { Name = "rt-jenkins" }
}

resource "aws_route_table_association" "jenkins-rt-association" {
  subnet_id      = aws_subnet.subnet_jenkins.id
  route_table_id = aws_route_table.rt_jenkins.id
}

resource "aws_security_group" "sg_jenkins" {
  vpc_id      = aws_vpc.jenkins_vpc.id

ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTPS connections"
  }
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }
egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = { Name = "sg-sq" }
}

resource "aws_instance" "jenkins" {
  ami                         = var.jenkins_ec2_ami
  instance_type               = var.jenkins_ec2_instance_type
  subnet_id                   = aws_subnet.subnet_jenkins.id
  vpc_security_group_ids      = [aws_security_group.sg_jenkins.id]
  associate_public_ip_address = true
  key_name = "win11-key"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > jenkins-pub-ip.txt"
  }

  tags = { Name = "jenkins" }
  }
