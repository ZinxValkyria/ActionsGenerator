function handleTaskChange() {
    const task = document.getElementById('task').value;
    const deployList = document.getElementById('deploylist');

    if (task === 'deploy') {
        deployList.style.display = 'block';  // Show deploy options if 'deploy' is selected
    } else {
        deployList.style.display = 'none';   // Hide deploy options for non-deploy tasks
        fetchTask(task);                     // Fetch YAML for non-deploy tasks
    }
}

function handleGCPDeploy() {
    const deployTask = document.getElementById('deploy_task').value;
    let deployUrl = '';

    // Map deploy task to its folder and YAML file
    switch (deployTask) {
        case 'g_app':
            console.log('Deploying to Google App engine...');
            deployUrl = `/scripts/gcp/app_engine.yaml`;
            break;
        case 'g_ce':
            console.log('Deploying to Google Compute Engine...');
            deployUrl = `/scripts/gcp/gce.yaml`;
            break;
        case 'g_ke':
            console.log('Deploying to ECR...');
            deployUrl = `/scripts/gcp/gke.yaml`;
            break;
        case 'g_cf':
            console.log('Deploying to Google cloud function...');
            deployUrl = `/scripts/gcp/g_cf.yaml`;
            break;
        default:
            console.log('Unknown deploy task');
            return;  // Exit early if the task is unknown
    }

    // Fetch and display the YAML content
    fetch(deployUrl)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok'); // More detailed error handling
            }
            return response.text();
        })
        .then(script => {
            document.getElementById('scriptOutput').textContent = script;
        })
        .catch(error => {
            console.error('Error fetching YAML:', error);  // Log the error for debugging
            document.getElementById('scriptOutput').textContent = 'Error fetching YAML script.';
        });
}

function fetchTask(task) {
    // Adjust path for non-deploy tasks if necessary
    const taskUrl = `/scripts/${task}.yaml`;  // Fetch the task YAML from /scripts folder

    fetch(taskUrl)
        .then(response => {
            return response.text();
        })
        .then(script => {
            document.getElementById('scriptOutput').textContent = script;
        })
        .catch(error => {
            console.error('Error fetching YAML:', error);
            document.getElementById('scriptOutput').textContent = 'Error fetching YAML script.';
        });
}
