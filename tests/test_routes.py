from app import app
from flask import Flask
import os
import pytest
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))


@pytest.fixture
def client():
    app.config["TESTING"] = True
    app.config["DEBUG"] = False
    with app.test_client() as client:
        yield client  # This will be the test client


def test_homepage(client):
    """Test the homepage route"""
    response = client.get("/")
    assert response.status_code == 200
    assert (
        b"Welcome to the GitHub Actions YAML Generator" in response.data
    )  # Check the specific content
    assert (
        b"This tool helps you generate GitHub Actions YAML scripts" in response.data
    )  # Additional content check


def test_aws_page(client):
    """Test the AWS page route"""
    response = client.get("/aws")
    assert response.status_code == 200
    assert b"AWS" in response.data  # Replace with actual content in aws.html


def test_github_page(client):
    """Test the GitHub page route"""
    response = client.get("/github")
    assert response.status_code == 200
    assert b"GitHub" in response.data  # Replace with actual content in github.html


def test_gcp_page(client):
    """Test the GCP page route"""
    response = client.get("/gcp")
    assert response.status_code == 200
    assert b"GCP" in response.data  # Replace with actual content in gcp.html


def test_custom_page(client):
    """Test the Docker page route"""
    response = client.get("/custom")
    assert response.status_code == 200
    assert b"workflow" in response.data  # Replace with actual content in docker.html


def test_azure_page(client):
    """Test the Azure page route"""
    response = client.get("/azure")
    assert response.status_code == 200
    assert b"Azure" in response.data  # Replace with actual content in azure.html


def test_fetch_yaml(client):
    """Test fetching a YAML file from the scripts directory"""
    # Replace 'example.yaml' with a valid YAML filename you expect to exist in the 'scripts' directory
    response = client.get("/scripts/aws/s3.yaml")
    assert response.status_code == 200  # Expect to find the file


def test_fetch_yaml_not_found(client):
    """Test fetching a non-existent YAML file"""
    response = client.get("/scripts/na.yaml")
    assert response.status_code == 404  # Expect 404 for non-existent file
