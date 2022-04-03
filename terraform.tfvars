cluster_name      = "benitezeks"
cluster_role_name = "eks-cluster-role"
worker_role_name  = "eks-node-group-role"
lambda_role_name  = "eks-lambda-role"
vpc_id            = "vpc-xxxxxxxxxxxxxxxxx"
subnet_ids        = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxxx", "subnet-xxxxxxxxxxxxxxxxx"]
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
