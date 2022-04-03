# Terraform module to create a simple EKS cluster

## Pré-requisites:

 - Terraform 1.1.3 installed
 - Already created role for the cluster
 - Already created role for node-groups (worker)
 - Already created role for lambda functions

```
eks-cluster-role

AWS managed policies:
AmazonEKSClusterPolicy
AmazonEKSVPCResourceController

Trust Policy:
eks.amazonaws.com
```

```
eks-node-group-role

AWS managed policies:
AmazonEKSWorkerNodePolicy
AmazonEKS_CNI_Policy`
AmazonEC2ContainerRegistryReadOnly
AmazonSSMManagedInstanceCore

Trust Policy:
ec2.amazonaws.com
```

```
eks-lambda-role

Costumer managed policy:
Version = "2012-10-17"
Statement = [
    {
        Effect = "Allow"
        Action = [
            "logs:CreateLogGroup",
        ]
        Resource = "arn:aws:logs:us-east-1:*:*"
    },
    {
        Effect = "Allow"
        Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:us-east-1:*:log-group:/aws/lambda/*"
    },
    {
        Effect = "Allow"
        Action = [
            "ec2:CreateTags"
        ]
        Resource = "arn:aws:ec2:us-east-1:*:subnet/*"
    },
    {
        Effect = "Allow"
        Action = [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
    }
]

Trust Policy:
lambda.amazonaws.com
```

## Edit file terraform.tfvars
- Set cluster name
- Set cluster role name



## Finally execute:

```
$ terraform fmt
$ terraform init
$ terraform plan -out=out.plan
$ terraform apply out.plan