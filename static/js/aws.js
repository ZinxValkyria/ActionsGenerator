function handleTaskChange() {
    const task = document.getElementById('task').value;
    const deployList = document.getElementById('deployList');
    const scriptOutput = document.getElementById('scriptOutput');

    if (task === 'deploy') {
        deployList.style.display = 'block';
        scriptOutput.textContent = ''; // Clear previous output
    } else {
        deployList.style.display = 'none';
        if (task === '/scripts/aws/aws_cli.yaml') {
            loadYaml(task); // Load AWS CLI YAML when selected
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
    tempTextarea.setSelectionRange(0, 99999);
    navigator.clipboard.writeText(tempTextarea.value).then(() => {
        alert("Copied the YAML successfully!");
    }).catch(err => {
        console.error("Failed to copy YAML: ", err);
    });
    document.body.removeChild(tempTextarea);
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
        's3': { url: '/scripts/aws/s3.yaml', infoId: 's3' },
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

                // Update additional content based on the filePath
                switch (filePath) {
                    case '/scripts/aws/ec2.yaml':
                        rightContent.innerHTML = '<h3>EC2 Deployment</h3><p>Deploy to EC2 instances.</p>';
                        break;
                    case '/scripts/aws/s3.yaml':
                        rightContent.innerHTML = '<h3>S3 Deployment</h3><p>Deploy to S3 buckets.</p>';
                        break;
                    case '/scripts/aws/ecr.yaml':
                        rightContent.innerHTML = '<h3>ECR Deployment</h3><p>Deploy to ECR (Elastic Container Registry).</p>';
                        break;
                    case '/scripts/aws/ecs.yaml':
                        rightContent.innerHTML = '<h3>ECS Deployment</h3><p>Deploy to ECS (Elastic Container Service).</p>';
                        break;
                    case '/scripts/aws/eks.yaml':
                        rightContent.innerHTML = '<h3>EKS Deployment</h3><p>Deploy to EKS (Elastic Kubernetes Service).</p>';
                        break;
                    case '/scripts/aws/lambda.yaml':
                        rightContent.innerHTML = '<h3>Lambda Deployment</h3><p>Deploy to AWS Lambda.</p>';
                        break;
                    case '/scripts/aws/aws_cli.yaml':
                        rightContent.innerHTML = '<h3>AWS CLI Commands</h3><p>Here are the AWS CLI commands.</p>';
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
