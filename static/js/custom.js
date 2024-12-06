// Generate YAML script by sending form data to Flask server
function generateYaml() {
    const form = document.getElementById('customForm');
    const formData = new FormData(form);

    fetch('/generate_yaml', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        // Display the generated YAML in the output section
        document.getElementById('scriptOutput').textContent = data.yaml;
    })
    .catch(error => {
        console.error('Error:', error);
    });
}

// Copy YAML content to clipboard
function copyYaml() {
    const yamlOutput = document.getElementById("scriptOutput").textContent;
    navigator.clipboard.writeText(yamlOutput).then(() => {
        alert("Copied to clipboard!");
    });
}