data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  description = "KMS Key for EKS resources"
}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  version                              = "17.24.0"
  cluster_name                         = var.cluster_name
  cluster_version                      = "1.21"
  enable_irsa                          = true
  manage_cluster_iam_resources         = false
  cluster_iam_role_name                = var.cluster_role_name
  manage_worker_iam_resources          = false
  cluster_enabled_log_types            = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_create_security_group        = false
  cluster_security_group_id            = aws_security_group.controlplane.id
  worker_create_security_group         = false
  worker_security_group_id             = aws_security_group.worker_group.id
  vpc_id                               = var.vpc_id
  subnets                              = var.subnet_ids
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  cluster_service_ipv4_cidr            = "172.20.0.0/16"
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.this.arn
      resources        = ["secrets"]
    }
  ]
  node_groups_defaults = {
    iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${var.worker_role_name}"
    custom_ami = {
      ami_id                     = var.ami_id
      enable_bootstrap_user_data = true
    }
    public_ip      = true
    instance_types = var.instance_types
    disk_size      = "80"
    disk_type      = "gp3"
    disk_encrypted = true
    update_config = {
      max_unavailable_percentage = 20
    }
    create_launch_template = true
  }
  node_groups = {
    group-1 = {
      name             = "${var.cluster_name}-group-1"
      min_capacity     = var.min_size
      max_capacity     = var.max_size
      desired_capacity = var.desired_size
    }
    group-2 = {
      name             = "${var.cluster_name}-group-2"
      min_capacity     = var.min_size
      max_capacity     = var.max_size
      desired_capacity = var.desired_size
    }
  }
  map_roles = var.worker_role_name == "" ? var.map_roles : concat(var.map_roles,
    [
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:/role/${var.worker_role_name}"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ]
  )
  depends_on = [
    aws_kms_key.this
  ]
}

resource "kubernetes_storage_class" "this" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    type      = "gp3"
    encrypted = "true"
    fsType    = "ext4"
  }
}