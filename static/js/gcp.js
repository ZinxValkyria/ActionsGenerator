function handleTaskChange() {
    const task = document.getElementById('task').value;
    const deployList = document.getElementById('deployList');
    const scriptOutput = document.getElementById('scriptOutput');

    if (task === 'deploy') {
        deployList.style.display = 'block';
        scriptOutput.textContent = ''; // Clear previous output
    } else {
        deployList.style.display = 'none';
        if (task === '/scripts/gcp/gcp_cli.yaml') {
            loadYaml(task); // Load GCP CLI YAML when selected
        } else {
            scriptOutput.textContent = ''; // Clear output for other tasks
        }
    }
}

function copyPre() {
    // Get the content of the <pre> element
    const preText = document.getElementById("scriptOutput").textContent;
  
    // Create a temporary textarea to enable copying the content
    const tempTextarea = document.createElement("textarea");
    tempTextarea.value = preText;
  
    // Add it to the document, select the content, and copy it
    document.body.appendChild(tempTextarea);
    tempTextarea.select();
    tempTextarea.setSelectionRange(0, 99999); // For mobile compatibility
  
    // Copy the content to the clipboard
    navigator.clipboard.writeText(tempTextarea.value).then(() => {
        alert("Copied the YAML successfully!");
    }).catch(err => {
        console.error("Failed to copy YAML: ", err);
    });
  
    // Remove the temporary textarea element
    document.body.removeChild(tempTextarea);
}

function loadYaml(filePath) {
    const rightContent = document.getElementById('contentOutput');

    if (filePath) {
        fetch(filePath)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Could not load file: ' + filePath);
                }
                return response.text();
            })
            .then(data => {
                document.getElementById('scriptOutput').textContent = data;

                // Set additional configuration details based on the selected GCP service
                switch (filePath) {
                    case '/scripts/gcp/app_engine.yaml':
                        rightContent.innerHTML = '<h3>Google App Engine</h3><p>Deploy scalable web applications using Google App Engine.</p>';
                        break;
                    case '/scripts/gcp/gce.yaml':
                        rightContent.innerHTML = '<h3>Google Compute Engine</h3><p>Deploy virtual machines on Google Compute Engine.</p>';
                        break;
                    case '/scripts/gcp/gke.yaml':
                        rightContent.innerHTML = '<h3>Google Kubernetes Engine</h3><p>Deploy containerized applications on GKE.</p>';
                        break;
                    case '/scripts/gcp/gcf.yaml':
                        rightContent.innerHTML = '<h3>Google Cloud Functions</h3><p>Deploy event-driven functions with Google Cloud Functions.</p>';
                        break;
                    default:
                        rightContent.innerHTML = ''; // Clear content if no matching case
                        break;
                }
            })
            .catch(error => {
                document.getElementById('scriptOutput').textContent = 'Error: ' + error.message;
            });
    } else {
        document.getElementById('scriptOutput').textContent = '';
    }
}
