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
    let content = document.getElementById('right-content');
    
    // Clear any previously displayed information
    const infoElements = ['s3_info', 'ec2_info', 'ecr_info', 'ecs_info', 'eks_info', 'lambda_info'];
    infoElements.forEach(id => {
        const element = document.getElementById(id);
        if (element) {
            element.style.display = 'none';  // Hide all info elements
        }
    });

    // Map deploy tasks to their corresponding YAML file and info element
    const deployMap = {
        's3': { url: '/scripts/aws/s3.yaml', infoId: 's3_info' },
        'ec2': { url: '/scripts/aws/ec2.yaml', infoId: 'ec2_info' },
        'ecr': { url: '/scripts/aws/ecr.yaml', infoId: 'ecr_info' },
        'ecs': { url: '/scripts/aws/ecs.yaml', infoId: 'ecs_info' },
        'eks': { url: '/scripts/aws/eks.yaml', infoId: 'eks_info' },
        'lambda': { url: '/scripts/aws/aws_lambda.yaml', infoId: 'lambda_info' }
    };

    // Check if the selected deploy task exists in the map
    if (deployMap[deployTask]) {
        const { url, infoId } = deployMap[deployTask];
        console.log(`Deploying to ${deployTask.toUpperCase()}...`);
        deployUrl = url;

        // Show the relevant info section
        const infoElement = document.getElementById(infoId);
        if (infoElement) {
            infoElement.style.display = 'block';  // Show the corresponding info element
        }
    } else {
        console.log('Unknown deploy task');
    }
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
