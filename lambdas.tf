data "archive_file" "lambda_tag_subnet_code" {
  type        = "zip"
  source_file = "${path.module}/lambdas/tag_subnet.py"
  output_path = "${path.module}/lambdas/tag_subnet.zip"
}

resource "aws_lambda_function" "tag_subnet" {
  function_name = "${var.cluster_name}_tag_subnet"
  runtime       = "python3.9"
  filename      = "${path.module}/lambdas/tag_subnet.zip"
  role          = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${var.lambda_role_name}"
  handler       = "tag_subnet.lambda_handler"
}

resource "aws_lambda_invocation" "tag_subnet" {
  function_name = aws_lambda_function.tag_subnet.function_name
  input = jsonencode({
    cluster_name = "${var.cluster_name}"
    subnet_ids   = "${var.subnet_ids}"
  })
}

data "archive_file" "lambda_delete_gp2_sc_code" {
  type        = "zip"
  source_file = "${path.module}/lambdas/delete_gp2_sc.py"
  output_path = "${path.module}/lambdas/delete_gp2_sc.zip"
}

resource "aws_lambda_function" "delete_gp2_sc" {
  function_name = "${var.cluster_name}_delete_gp2_sc"
  runtime       = "python3.9"
  filename      = "${path.module}/lambdas/delete_gp2_sc.zip"
  role          = "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${var.lambda_role_name}"
  handler       = "delete_gp2_sc.lambda_handler"
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.eks_lambda.id]
  }
}

resource "aws_lambda_invocation" "delete_gp2_sc" {
  function_name = aws_lambda_function.delete_gp2_sc.function_name
  input = jsonencode({
    url   = data.aws_eks_cluster.this.endpoint
    token = data.aws_eks_cluster_auth.this.token
  })
}