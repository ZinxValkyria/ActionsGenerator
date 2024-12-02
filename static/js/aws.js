// Task handling
function handleTaskChange() {
    const task = document.getElementById('task').value;
    const deployList = document.getElementById('deployList');
    const scriptOutput = document.getElementById('scriptOutput');

    switch (task) {
        case 'deploy':
            deployList.style.display = 'block';
            scriptOutput.textContent = ''; // Clear previous output
            break;

        case '/scripts/aws/aws_cli.yaml':
        case '/scripts/aws/login.yaml':
        case '/scripts/aws/logs.yaml':
            loadYaml(task); // Pass the task value to loadYaml
            deployList.style.display = 'none';
            break;

        default:
            console.warn('Unhandled task:', task);
    }
}


// Copy button functionality
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


// loading YAML files from the server
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
