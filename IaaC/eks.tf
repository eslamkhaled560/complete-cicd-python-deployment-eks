module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.4"

  cluster_name = var.cluster_name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs-csi.iam_role_arn
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group
  eks_managed_node_group_defaults = {
    ami_type       = var.node_group_ami
    instance_types = var.node_group_instance_types

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    eks_node_group = {
      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_types = var.node_group_instance_types
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "node-group"
      }
    }
  }

  node_security_group_tags = {
        "kubernetes.io/cluster/${var.cluster_name}" = null
  }
}