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

function handleAWSDeploy() {
    const deployTask = document.getElementById('deploy_task').value;
    let deployUrl = '';

    // Map deploy task to its folder and YAML file
    switch (deployTask) {
        case 's3':
            console.log('Deploying to S3...');
            deployUrl = `/scripts/aws/s3.yaml`;
            break;
        case 'ec2':
            console.log('Deploying to EC2...');
            deployUrl = `/scripts/aws/ec2.yaml`;
            break;
        case 'ecr':
            console.log('Deploying to ECR...');
            deployUrl = `/scripts/aws/ecr.yaml`;
            break;
        case 'ecs':
            console.log('Deploying to ECS...');
            deployUrl = `/scripts/aws/ecs.yaml`;
            break;
        case 'eks':
            console.log('Deploying to EKS...');
            deployUrl = `/scripts/aws/eks.yaml`;
            break;
        case 'lambda':  // Ensure 'lambda' is lowercase to match file names
            console.log('Deploying to AWS Lambda...');
            deployUrl = `/scripts/aws/lambda.yaml`;
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
