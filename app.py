"""
This module initializes and configures a Flask web application.
It serves HTML pages and provides an endpoint to fetch local
YAML script files from the 'scripts' directory.
"""

import os
from flask import Flask, render_template, send_from_directory, abort, jsonify, request
import newrelic.agent
# from dotenv import load_dotenv

app = Flask(__name__, template_folder="templatesv2")
# load_dotenv()

#  YAML scripts are stored
SCRIPTS_DIR = os.path.join(os.getcwd(), "scripts")

# Ensure scripts directory exists
if not os.path.exists(SCRIPTS_DIR):
    raise FileNotFoundError(
        f"The directory {SCRIPTS_DIR} does not exist. Please check your project structure."
    )


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
    Renders the homepage (home.html).

    Returns:
        The rendered HTML template for the homepage.
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


#  Route to fetch YAML files from local storage
@app.route("/scripts/<path:filename>", methods=["GET"])
def fetch_yaml(filename):
    """
    Fetches a YAML file from the scripts directory.

    Args:
        filename (str): The name of the YAML file to retrieve.

    Returns:
        A file if it exists in the 'scripts' directory, or a 404 error if the file is not found.
    """
    file_path = os.path.join(SCRIPTS_DIR, filename)

    # Check if the file exists
    if os.path.isfile(file_path):
        return send_from_directory(SCRIPTS_DIR, filename)

    # If the file doesn't exist, return error
    return abort(404, description="File not found")


@app.route('/generate_yaml', methods=['POST'])
def generate_yaml():
    # Get form data from the frontend
    workflow_name = request.form.get('workflow_name')
    triggers = request.form.getlist('triggers')  # List of selected triggers
    job_name = request.form.get('job_name')
    runs_on = request.form.get('runs_on')
    steps = request.form.get('steps')
    uses_action = request.form.get('uses_action')
    run_command = request.form.get('run')

    # Prepare the trigger events string
    trigger_events = "\n  ".join([f"{trigger}:" for trigger in triggers])

    # Construct the YAML template
    yaml_template = """
name: {{workflow_name}}

on:
  {{trigger_events}}

jobs:
  {{job_name}}:
    runs-on: {{runs_on}}

    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      - name: {{uses_action}}
        run: |
          {{run_command}}
"""

    # Replace the placeholders with the actual values
    yaml_content = yaml_template.replace("{{workflow_name}}", workflow_name) \
        .replace("{{trigger_events}}", trigger_events) \
        .replace("{{job_name}}", job_name) \
        .replace("{{runs_on}}", runs_on) \
        .replace("{{steps}}", steps) \
        .replace("{{uses_action}}", uses_action) \
        .replace("{{run_command}}", run_command)

    # Return the YAML content as JSON
    return jsonify({"yaml": yaml_content})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
