"""
This module initializes and configures a Flask web application.
It serves HTML pages and provides an endpoint to fetch YAML script files from S3.
"""

import logging
import os

import yaml
from botocore.exceptions import ClientError
from flask import Flask, render_template, Response, abort, jsonify, request
import boto3
logger = logging.getLogger(__name__)

app = Flask(__name__, template_folder="templatesv2")

# AWS S3 configuration
S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME", "actions-template-bucket")
AWS_REGION = os.getenv("AWS_REGION", "eu-west-1")
s3_client = boto3.client("s3", region_name=AWS_REGION)  # Ensure AWS credentials and region are configured


# Route for the homepage
@app.route("/")
def home():
    """
    Renders the homepage (home.html).

    Returns:
        The rendered HTML template for the homepage.
    """
    return render_template("home.html")


@app.route("/test")
def test():
    """
    Renders the homepage (test.html).

    Returns:
        The rendered HTML template for the test page.
    """
    return render_template("test.html")


# Route for AWS page
@app.route("/aws")
def aws():
    """
    Renders the AWS page (aws.html).

    Returns:
        The rendered HTML template for the AWS page.
    """
    return render_template("aws.html")


# Route for GitHub page
@app.route("/github")
def github():
    """
    Renders the GitHub page (github.html).

    Returns:
        The rendered HTML template for the GitHub page.
    """
    return render_template("github.html")


# Route for GCP page
@app.route("/gcp")
def gcp():
    """
    Renders the GCP page (gcp.html).

    Returns:
        The rendered HTML template for the GCP page.
    """
    return render_template("gcp.html")


# Route for Docker page
@app.route("/docker")
def docker():
    """
    Renders the Docker page (docker.html).

    Returns:
        The rendered HTML template for the Docker page.
    """
    return render_template("docker.html")


# Route for Azure page
@app.route("/azure")
def azure():
    """
    Renders the Azure page (azure.html).

    Returns:
        The rendered HTML template for the Azure page.
    """
    return render_template("azure.html")


# Route for GitHub Pages (Custom page)
@app.route("/custom")
def gh_pages():
    """
    Renders the custom GitHub Pages page (custom.html).

    Returns:
        The rendered HTML template for the custom GitHub Pages page.
    """
    return render_template("custom.html")


# Route to fetch YAML files from S3
@app.route("/scripts/<service>/<path:filename>", methods=["GET"])
def fetch_yaml(service, filename):
    """
    Fetches a YAML file from the S3 bucket, organized by service-specific subdirectories.

    Args:
        service (str): The subdirectory in the S3 bucket (e.g., 'aws', 'azure').
        filename (str): The name of the YAML file to retrieve.

    Returns:
        The file content as a response, or a 404 error if the file is not found.
    """
    try:
        # Construct the S3 key using the service and filename
        key = f"scripts/{service}/{filename}"
        s3_response = s3_client.get_object(Bucket=S3_BUCKET_NAME, Key=key)
        file_content = s3_response["Body"].read()

        # Return the file content as a response
        return Response(
            file_content,
            mimetype="application/x-yaml",
            headers={"Content-Disposition": f"attachment; filename={filename}"}
        )
    except ClientError as exc:
        if exc.response.get("Error", {}).get("Code") in {"NoSuchKey", "404"}:
            return abort(404, description="Template not found")
        logger.exception("S3 failed while fetching %s", key)
        return abort(502, description="Unable to retrieve template")
    except Exception:
        logger.exception("Unexpected error while fetching %s", key)
        return abort(500, description="Unable to retrieve template")


# Route to dynamically generate YAML based on a template from S3
@app.route('/generate_yaml', methods=['POST'])
def generate_yaml():
    """
    Generates a YAML file by replacing placeholders in a base YAML template fetched from S3.

    Returns:
        JSON response containing the generated YAML content.
    """
    try:
        # Get form data from the frontend
        workflow_name = request.form.get('workflow_name')
        triggers = request.form.getlist('triggers')  # List of selected triggers
        job_name = request.form.get('job_name')
        runs_on = request.form.get('runs_on')
        steps = request.form.get('steps')
        uses_action = request.form.get('uses_action')
        run_command = request.form.get('run')

        required_fields = {
            "workflow_name": workflow_name,
            "job_name": job_name,
            "runs_on": runs_on,
        }
        missing = [name for name, value in required_fields.items() if not value or not value.strip()]
        if missing:
            return jsonify({"error": f"Missing required fields: {', '.join(missing)}"}), 400
        if not triggers:
            return jsonify({"error": "Select at least one trigger"}), 400

        trigger_events = "\n  ".join([f"{trigger}:" for trigger in triggers])

        # Fetch the base YAML from S3
        key = "scripts/custom/base.yaml"
        s3_response = s3_client.get_object(Bucket=S3_BUCKET_NAME, Key=key)
        base_yaml_content = s3_response["Body"].read().decode("utf-8")

        # Replace the placeholders with the actual values
        yaml_content = base_yaml_content.replace("{{workflow_name}}", workflow_name) \
            .replace("{{trigger_events}}", trigger_events) \
            .replace("{{job_name}}", job_name) \
            .replace("{{runs_on}}", runs_on) \
            .replace("{{steps}}", steps) \
            .replace("{{uses_action}}", uses_action) \
            .replace("{{run_command}}", run_command)

        try:
            parsed_yaml = yaml.safe_load(yaml_content)
            yaml_content = yaml.safe_dump(parsed_yaml, sort_keys=False)
        except yaml.YAMLError:
            return jsonify({"error": "The supplied values produced invalid YAML"}), 400

        return jsonify({"yaml": yaml_content})

    except ClientError as exc:
        if exc.response.get("Error", {}).get("Code") in {"NoSuchKey", "404"}:
            return abort(404, description="Base template not found")
        logger.exception("S3 failed while generating YAML")
        return abort(502, description="Unable to retrieve the base template")
    except Exception:
        logger.exception("Unexpected YAML generation error")
        return abort(500, description="Unable to generate workflow")


# Start the Flask app
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)