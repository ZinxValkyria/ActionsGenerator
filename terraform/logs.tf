resource "aws_iam_role" "firehose_role" {
  name = "firehose-log-forwarding-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess"
}

resource "aws_kinesis_firehose_delivery_stream" "log_forwarding_stream" {
  name        = "cloudwatch-to-newrelic-stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    url        = "https://log-api.newrelic.com/log/v1" # New Relic Log API endpoint
    access_key = var.new_relic_license_key             # New Relic Insert API Key
    name       = "NewRelicLogEndpoint"                 # Required field to provide a valid name

    s3_configuration {
      role_arn           = aws_iam_role.firehose_role.arn
      bucket_arn         = "arn:aws:s3:::newrelictest2"
      buffering_interval = 300 # in seconds
      buffering_size     = 5   # in MB
      compression_format = "UNCOMPRESSED"
    }

    role_arn = aws_iam_role.firehose_role.arn
  }
}
