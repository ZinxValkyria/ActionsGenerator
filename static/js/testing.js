function handleTaskChange() {
  const task = document.getElementById('task').value;
  const deployList = document.getElementById('deployList');

  if (task === 'deploy') {
    deployList.style.display = 'block';
     loadYaml();
  } else {
      deployList.style.display = 'none';  
      document.getElementById('scriptOutput').textContent = ''; 
  }
}

function loadYaml() {
  const deploy_task = document.getElementById('deploy_task').value;

  const right_content = document.getElementById('contentOutput');

  document.getElementById('deploy_task').addEventListener('change', function() {
    const filePath = this.value;

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
          
  switch (deploy_task) {
    case '/scripts/aws/ec2.yaml':
        right_content.innerHTML = '<h3>EC2 Deployment</h3><p>Deploy to EC2 instances.</p>';
        break;
  
    default:
        right_content.innerHTML = ''; // Clear content if no matching case
        break;
}

        })
        .catch(error => {
          document.getElementById('scriptOutput').textContent = 'Error: ' + error.message;
        });
    } else {
      document.getElementById('scriptOutput').textContent = '';
    }
  });
}

function loadAdditionalContent() {
  const deploy_task = document.getElementById('deploy_list').value;
  const right_content = document.getElementById('contentOutput');

  
  switch (deploy_task) {
    case '/scripts/aws/ec2.yaml':
      right_content.innerHTML = '<h3>EC2 Deployment</h3><p>Deploy to EC2 instances.</p>';
      break;
    case '/scripts/gcp/auth.yaml':
      right_content.innerHTML = '<h3>GCP Deployment</h3><p>Deploy to GCP instances.</p>';
      break;
    default:// Clear content if no matching case
      break;
  }
}

