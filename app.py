import os
from flask import Flask, render_template, send_from_directory, abort

app = Flask(__name__, template_folder='templatesv2')

# Define the directory where local YAML scripts are stored
SCRIPTS_DIR = os.path.join(os.getcwd(), 'scripts')

# Ensure that the scripts directory exists
if not os.path.exists(SCRIPTS_DIR):
    raise FileNotFoundError(f"The directory {SCRIPTS_DIR} does not exist. Please check your project structure.")

# Route for the homepage
@app.route('/')
def home():
    return render_template('home.html')

# Route for AWS page
@app.route('/aws')
def aws():
    return render_template('aws.html')

# Route for GitHub page
@app.route('/github')
def github():
    return render_template('github.html')

# Route for GCP page
@app.route('/gcp')
def gcp():
    return render_template('gcp.html')

# Route for Docker page
@app.route('/docker')
def docker():
    return render_template('docker.html')

# Route for Azure page
@app.route('/azure')
def azure():
    return render_template('azure.html')

# Route for GitHub Pages (Custom page)
@app.route('/custom')
def gh_pages():
    return render_template('custom.html')


# Route to fetch YAML files from local storage
@app.route('/scripts/<path:filename>', methods=['GET'])
def fetch_yaml(filename):
    file_path = os.path.join(SCRIPTS_DIR, filename)
    
    # Check if the file exists before sending it
    if os.path.isfile(file_path):
        return send_from_directory(SCRIPTS_DIR, filename)
    else:
        return abort(404, description="File not found")

if __name__ == '__main__':
    app.run(debug=True)
