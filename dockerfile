# Use the official Python image from the Docker Hub
<<<<<<< HEAD
<<<<<<< HEAD
FROM python:3.11
=======
FROM python:3.8-slim
>>>>>>> 41bbf93 (various tweaks)
=======
FROM python:3.8-slim
>>>>>>> 41bbf937c31d70a55ec4a5d6e4f72d8afde14400

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Copy the .env file into the container
<<<<<<< HEAD
<<<<<<< HEAD
# COPY .env /app/.env

# Copy the New Relic configuration file
 COPY newrelic.ini /app/newrelic.ini
=======
=======
>>>>>>> 41bbf937c31d70a55ec4a5d6e4f72d8afde14400
COPY .env /app/.env

# Copy the New Relic configuration file
COPY newrelic.ini /app/newrelic.ini
<<<<<<< HEAD
>>>>>>> 41bbf93 (various tweaks)
=======
>>>>>>> 41bbf937c31d70a55ec4a5d6e4f72d8afde14400

# Expose port 5000 for the Flask application
EXPOSE 5000

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
ENV NEW_RELIC_CONFIG_FILE=/app/newrelic.ini

<<<<<<< HEAD
<<<<<<< HEAD
# Run the Flask application using New Relic
CMD ["newrelic-admin", "run-program", "flask", "run"]
=======
# Run the Flask application with New Relic monitoring
CMD ["newrelic-admin", "run-program", "python3", "app.py"]
>>>>>>> 41bbf93 (various tweaks)
=======
# Run the Flask application with New Relic monitoring
CMD ["newrelic-admin", "run-program", "python3", "app.py"]
>>>>>>> 41bbf937c31d70a55ec4a5d6e4f72d8afde14400
