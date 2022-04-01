cluster_name      = "benitezeks"
cluster_role_name = "eks-cluster-role"
worker_role_name  = "eks-node-group-role"
lambda_role_name  = "eks-lambda-role"
vpc_id            = "vpc-030c87a25dd5d3d26"
subnet_ids        = ["subnet-00e7317c9b545ef96", "subnet-0f0c03820a18b8d55", "subnet-07c2e6509b606987a"]
desired_size      = 1
max_size          = 3
min_size          = 1
ami_id            = "ami-0e1b6f116a3733fef"
instance_types    = ["t2.micro"]
map_roles = [
  {
    "groups" : ["system:masters"],
    "rolearn" : "",
    "username" : "system:admin"
  }
]
