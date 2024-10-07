// Handle task selection
function handleTaskChange() {
    const taskSelect = document.getElementById('task');
    const customFlow = document.getElementById('custom_flow');
    const deployList = document.getElementById('deploylist');
    const deployTask = document.getElementById('deploy_task');

    // Show or hide custom workflow fields based on the selected task
    if (taskSelect.value === 'custom') {
        customFlow.style.display = 'block';  // Show custom workflow options
        deployList.style.display = 'none'; 
        // document.getElementById('scriptOutput').textContent = '';  // Hide deploy options
    } else if (taskSelect.value === 'deploy') {
        deployList.style.display = 'block';  // Show deploy options
        customFlow.style.display = 'none'; 
        document.getElementById('scriptOutput').textContent = '';  // Hide deploy options
        // Hide custom workflow options
        // Handle deployment task once it's selected
        deployTask.addEventListener('change', () => {
            fetchFromLocal(taskSelect.value, deployTask.value);
        });

            // Handle task selection change
            taskSelect.addEventListener('change', () => {
                if (taskSelect.value === 'custom') {
                    customFlow.style.display = 'block';  // Show custom workflow options
                    deployList.style.display = 'none'; 
                } else if (taskSelect.value === 'deploy') {
                    deployList.style.display = 'block';  // Show deploy options
                    customFlow.style.display = 'none'; 
                } else {
                    customFlow.style.display = 'none';   // Hide custom workflow options
                    deployList.style.display = 'none';   // Hide deploy options
                }
            });
        
            // Handle form submission
            generateButton.addEventListener('click', () => {
                const taskValue = taskSelect.value;
                const deployTask = document.getElementById('deploy_task').value;
        
                fetchFromLocal(taskValue, deployTask);
            });
        
            // Fetch the YAML script from the local folder
            function fetchFromLocal(task, deploytask) {
                const taskurl = `/fetch_yaml/${task}.yaml`;
                fetch(taskurl)
                    .then(response => response.text())
                    .then(script => {
                        scriptOutput.textContent = script;
                    })
                    .catch(error => {
                        scriptOutput.textContent = 'Error fetching YAML script.';
                    });
        
                if (deploytask) {
                    const deployurl = `/fetch_yaml/${deploytask}.yaml`;
                    fetch(deployurl)
                        .then(response => response.text())
                        .then(script => {
                            scriptOutput.textContent += "\n" + script;
                            customFlow.style.display = 'none';   // Hide custom workflow options
                            deployList.style.display = 'none';   // Hide deploy options
                            fetchFromLocal(taskSelect.value);
                        })
                        .catch(error => {
                            scriptOutput.textContent = 'Error fetching deployment YAML script.';
                        });
                }
            }
        });
        
        customFlow.style.display = 'none';   // Hide custom workflow options
        deployList.style.display = 'none';   // Hide deploy options
        fetchFromLocal(taskSelect.value);
    }

// Fetch the YAML script from the local folder
function fetchFromLocal(task, deploytask) {
    const taskurl = `/fetch_yaml/${task}.yaml`;
    console.log(`Fetching ${taskurl}...`);
    fetch(taskurl)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.statusText);
            }
            return response.text();
        })
        .then(script => {
            console.log("YAML Script:", script);
            document.getElementById('scriptOutput').textContent = script;
        })
        .catch(error => {
            console.error('Error fetching YAML script:', error);
            // document.getElementById('scriptOutput').textContent = 'Error fetching YAML script.';
        });

    if (deploytask) {
        const deployurl = `/fetch_yaml/${deploytask}.yaml`;
        console.log(`Fetching ${deployurl}...`);
        fetch(deployurl)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.statusText);
                }
                return response.text();
            })
            .then(script => {
                console.log("YAML Script:", script);
                // Append deploy YAML to the existing task YAML
                document.getElementById('scriptOutput').textContent += "\n" + script;
            })
            .catch(error => {
                console.error('Error fetching deployment YAML script:', error);
                document.getElementById('scriptOutput').textContent = 'Error fetching deployment YAML script.';
            });
    }
}

// Add event listener for task selection change
document.getElementById('task').addEventListener('change', handleTaskChange);
