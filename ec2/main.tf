terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

variable "email" {
  type = string
}

# resource "aws_instance" "app_server" {
#   ami           = "ami-830c94e3"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ExampleAppServerInstance"
#   }
# }

resource "aws_iam_role" "ec2_test_role" {
  name = "ec2_test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  permissions_boundary = data.aws_iam_policy.boundary.arn
    
  tags = {
    Environment = "training"
    Purpose     = "Client POC"
    Email       = var.email
  }
}

data "aws_caller_identity" "current" {}
data "aws_iam_policy" "boundary" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ScopePermissions"
}

# resource "aws_iam_policy" "test_policy" {
#     name = "test_policy"
#     path = "/"
#     description = "Test policy"

#     policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#         {
#             Action = [
#             "ec2:Describe*",
#             ]
#             Effect   = "Allow"
#             Resource = "*"
#         },
#         ]
#     })
# }

# resource "aws_iam_role_policy_attachment" "test-attach" {
#   role       = aws_iam_role.ec2_test_role.name
#   policy_arn = data.aws_iam_policy.boundary.arn
# }
