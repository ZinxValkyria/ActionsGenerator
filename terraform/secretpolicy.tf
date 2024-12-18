
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

# Attach custom policy to allow S3 access
resource "aws_iam_policy" "s3_access_policy" {
  name = "ecs-s3-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject"],
        Resource = "arn:aws:s3:::actions-template-bucket/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Add Bucket Policy for allowing ECS Task to access it
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "actions-template-bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::188132471158:role/ecsTaskExecutionRole"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::actions-template-bucket/*"
      }
    ]
  })
}
