terraform {
  required_version = ">= 1.1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.8.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

#provider "kubernetes" {
#  host                   = data.aws_eks_cluster.this.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
#  exec {
#    api_version = "client.authentication.k8s.io/v1alpha1"
#    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
#    command     = "aws"
#  }
#}
