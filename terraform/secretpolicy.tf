
# Attach a Policy to Allow Secrets Manager Access
resource "aws_iam_policy" "ecs_secrets_access_policy" {
  name = "ecsSecretsAccessPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = [
          "arn:aws:acm:eu-west-1:188132471158:certificate/01dfe950-0751-4f57-9e4e-2f13ea9f0900"
        ]
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_secrets_access_policy.arn
}
