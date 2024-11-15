function handleTaskChange() {
    const task = document.getElementById('task').value;
    const deployList = document.getElementById('deployList');
    const scriptOutput = document.getElementById('scriptOutput');

    if (task === 'deploy') {
        deployList.style.display = 'block';
        scriptOutput.textContent = ''; // Clear previous output
    } else {
        deployList.style.display = 'none';
        if (task === '/scripts/azure/azure_cli.yaml') {
            loadYaml(task); // Load Azure CLI YAML when selected
        } else {
            scriptOutput.textContent = ''; // Clear output for other tasks
        }
    }
}

function copyPre() {
    const preText = document.getElementById("scriptOutput").textContent;
    const tempTextarea = document.createElement("textarea");
    tempTextarea.value = preText;
    document.body.appendChild(tempTextarea);
    tempTextarea.select();
    tempTextarea.setSelectionRange(0, 99999); // For mobile compatibility
    navigator.clipboard.writeText(tempTextarea.value).then(() => {
        alert("Copied the YAML successfully!");
    }).catch(err => {
        console.error("Failed to copy YAML: ", err);
    });
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
                
                // Set additional configuration details based on the selected Azure service
                switch (filePath) {
                    case '/scripts/azure/az_k8s.yaml':
                        rightContent.innerHTML = '<h3>Azure Kubernetes Service</h3><p>Deploy to AKS for containerized applications.</p>';
                        break;
                    case '/scripts/azure/az_web_app.yaml':
                        rightContent.innerHTML = '<h3>Azure Web App</h3><p>Deploy web applications using Azure Web App service.</p>';
                        break;
                    case '/scripts/azure/postgres.yaml':
                        rightContent.innerHTML = '<h3>Azure PostgreSQL</h3><p>Manage PostgreSQL databases on Azure.</p>';
                        break;
                    case '/scripts/azure/sql.yaml':
                        rightContent.innerHTML = '<h3>Azure SQL Database</h3><p>Deploy and manage SQL databases on Azure.</p>';
                        break;
                    case '/scripts/azure/static_site.yaml':
                        rightContent.innerHTML = '<h3>Azure Static Web Apps</h3><p>Deploy static sites and apps with Azure Static Web Apps service.</p>';
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
