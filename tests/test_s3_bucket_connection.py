import boto3
import pytest
import os
import dotenv

# Load environment variables
dotenv.load_dotenv()

# Retrieve environment variables
bucket_name = os.getenv("S3_BUCKET_NAME")

# Check if required environment variable is present
if not bucket_name:
    pytest.fail("S3_BUCKET_NAME environment variable is not set")

# Initialize the S3 client
s3_client = boto3.client("s3")

@pytest.mark.parametrize("bucket_name", [bucket_name])
def test_s3_bucket_ping(bucket_name):
    """
    Test if the S3 bucket is accessible by sending a head_bucket request.

    Args:
        bucket_name (str): Name of the S3 bucket.
    """
    try:
        # Perform a head_bucket call to check if the bucket is reachable
        response = s3_client.head_bucket(Bucket=bucket_name)
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200
        print(f"Successfully connected to the S3 bucket: {bucket_name}")
    except Exception as e:
        pytest.fail(f"Failed to connect to S3 bucket {bucket_name}: {e}")
