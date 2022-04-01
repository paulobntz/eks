resource "aws_security_group" "controlplane" {
  name        = "${var.cluster_name}_controlplane_sg"
  description = "EKS ${var.cluster_name} controlplane security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "controlplane_to_all" {
  type              = "egress"
  description       = "Allow controlplane to access everything"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.controlplane.id
}

resource "aws_security_group_rule" "worker_group_to_controlplane_https" {
  type                     = "ingress"
  description              = "Allow pods to communicate with the EKS cluster API."
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.worker_group.id
  security_group_id        = aws_security_group.controlplane.id
}

resource "aws_security_group_rule" "all_to_controlplane_https" {
  type              = "ingress"
  description       = "Allow all to communicate with the EKS cluster API."
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.controlplane.id
}

resource "aws_security_group" "worker_group" {
  name        = "${var.cluster_name}_worker_group_sg"
  description = "EKS ${var.cluster_name} worker groups security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "worker_group_to_all" {
  type              = "egress"
  description       = "Allow nodes all egress to the Internet."
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_group.id
}

resource "aws_security_group_rule" "worker_group_to_worker_group_all" {
  type                     = "ingress"
  description              = "Allow node to communicate with each other."
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.worker_group.id
  security_group_id        = aws_security_group.worker_group.id
}

resource "aws_security_group_rule" "controleplane_to_worker_group_https" {
  type                     = "ingress"
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.controlplane.id
  security_group_id        = aws_security_group.worker_group.id
}

resource "aws_security_group_rule" "controleplane_to_worker_group_high_ports" {
  type                     = "ingress"
  description              = "Allow workers pods to receive communication from the cluster control plane."
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.controlplane.id
  security_group_id        = aws_security_group.worker_group.id
}

resource "aws_security_group" "eks_lambda" {
  name        = "${var.cluster_name}_lambda_sg"
  description = "EKS ${var.cluster_name} lambda security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "eks_lambda" {
  type              = "egress"
  description       = "Allow EKS lambda all egress to the Internet."
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_lambda.id
}
