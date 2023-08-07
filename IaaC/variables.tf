variable "aws_region" {}

# Jenkins VPC
variable "jenkins_vpc_cidr_block" {}
variable "jenkins_subnet" {}
variable "jenkins_subnet_az" {}
variable "jenkins_cidr_block_rt" {}

# Jenkins EC2
variable "jenkins_ec2_ami" {}
variable "jenkins_ec2_instance_type" {}

# ECRs
variable "ecr_name" {}
variable "ecr_db" {}

# EKS VPC
variable "vpc_cidr_block" {}
variable "vpc_name" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}
variable "zones" {}

# EKS Module
variable "cluster_name" {}
variable "node_group_ami" {}
variable "node_group_instance_types" {}




