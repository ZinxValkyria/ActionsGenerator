import boto3
import pytest
import os
import dotenv
from botocore.exceptions import ClientError

# Load environment variables
dotenv.load_dotenv()

# Retrieve environment variables
file_key = os.getenv("S3_FILE_KEY")
bucket_name = os.getenv("S3_BUCKET_NAME")

# Check if required environment variables are present
if not file_key or not bucket_name:
    pytest.fail("S3_BUCKET_NAME or S3_FILE_KEY environment variable is not set")

# Initialize the S3 client
s3_client = boto3.client("s3")

def test_s3_file_exists():
    """
    Test if a specific file exists in the S3 bucket.

    Steps:
    - Check if the file exists using head_object.
    """
    try:
        # Attempt to fetch metadata for the specific file
        response = s3_client.head_object(Bucket=bucket_name, Key=file_key)
        # If the file exists, we should get metadata (status code 200)
        assert response["ResponseMetadata"]["HTTPStatusCode"] == 200
        print(f"File {file_key} exists in the S3 bucket {bucket_name}.")

    except ClientError as e:
        # Check if the error code is 'NoSuchKey', which means the file doesn't exist
        if e.response['Error']['Code'] == 'NoSuchKey':
            pytest.fail(f"File {file_key} does not exist in the S3 bucket {bucket_name}.")
        else:
            pytest.fail(f"Failed to check file {file_key} in S3 bucket {bucket_name}: {e}")
