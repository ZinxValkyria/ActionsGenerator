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
