module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.20.0"

  name                   = local.cluster_name
  kubernetes_version     = var.cluster_version
  endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  # vpc-cni и eks-pod-identity-agent до нод (before_compute), чтобы ENI/IAM для дата-плейна были готовы.
  # kube-proxy и coredns — стандартный плоскостной минимум для работы kubelet и DNS.
  addons = {
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
    eks-pod-identity-agent = {
      most_recent    = true
      before_compute = true
    }
    kube-proxy = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    default = {
      name = "default"

      instance_types = ["t3.medium"]
      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "ON_DEMAND"

      min_size     = 2
      max_size     = 2
      desired_size = 2
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = {
    Project = var.project_name
  }
}
