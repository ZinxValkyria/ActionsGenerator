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

function loadYaml() {
    const deployTaskElement = document.getElementById('task');
    const rightContent = document.getElementById('contentOutput');

    const filePath = deployTaskElement.value;

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

                // Update the right content based on the selected YAML file
                switch (filePath) {
                    case '/scripts/github/login.yaml':
                        rightContent.innerHTML = '<h3>Login to Dockerhub</h3><p>Log in to Dockerhub for pulling and pushing images.</p>';
                        break;
                    case '/scripts/github/build_push.yaml':
                        rightContent.innerHTML = '<h3>Build & Push Docker Image</h3><p>Build your Docker image and push it to the registry.</p>';
                        break;
                    case '/scripts/github/python_tests.yaml':
                        rightContent.innerHTML = '<h3>Run Pytest</h3><p>Execute your Python tests using pytest.</p>';
                        break;
                    case '/scripts/github/gh_pages.yaml':
                        rightContent.innerHTML = '<h3>Deploy to GitHub Pages</h3><p>Deploy your website to GitHub Pages.</p>';
                        break;
                    case '/scripts/github/linting.yaml':
                        rightContent.innerHTML = '<h3>Linting</h3><p>Run linters to check your code quality.</p>';
                        break;
                    case '/scripts/github/snyk.yaml':
                        rightContent.innerHTML = '<h3>Snyk</h3><p>Check for vulnerabilities in your dependencies.</p>';
                        break;
                    case '/scripts/github/setup_node.yaml':
                        rightContent.innerHTML = '<h3>Setup Node</h3><p>Prepare your environment for Node.js development.</p>';
                        break;
                    default:
                        rightContent.innerHTML = '<p>Select a task to see relevant details here.</p>'; // Default message
                        break;
                }
            })
            .catch(error => {
                document.getElementById('scriptOutput').textContent = 'Error: ' + error.message;
                rightContent.innerHTML = '<p>Select a task to see relevant details here.</p>'; // Clear right content on error
            });
    } else {
        document.getElementById('scriptOutput').textContent = '';
        rightContent.innerHTML = '<p>Select a task to see relevant details here.</p>'; // Default message
    }
}
