#########################################################
### Customize your variables by changing these values ###
#########################################################

aws_region = "us-east-1"

# Jenkins VPC
jenkins_vpc_cidr_block = "10.0.0.0/16"
jenkins_subnet = "10.0.0.0/24"
jenkins_subnet_az = "us-east-1a"
jenkins_cidr_block_rt = "0.0.0.0/0"

# Jenkins EC2
jenkins_ec2_ami = "ami-053b0d53c279acc90"           # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image
jenkins_ec2_instance_type = "t2.medium"

# ECRs
ecr_name = "ecr-pvt"
ecr_db = "ecr-db"

# EKS VPC
vpc_cidr_block = "10.0.0.0/16"
vpc_name = "vpc-eks"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
zones = ["us-east-1a", "us-east-1b"]

# EKS Module
cluster_name = "eks_master"
node_group_ami = "AL2_x86_64"
node_group_instance_types = ["t2.medium"]
