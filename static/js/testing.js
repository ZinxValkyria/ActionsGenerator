
  document.getElementById('workflowDropdown').addEventListener('change', function() {
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
          document.getElementById('yamlContent').textContent = data;
        })
        .catch(error => {
          document.getElementById('yamlContent').textContent = 'Error: ' + error.message;
        });
    } else {
      document.getElementById('yamlContent').textContent = '';
    }
  });

