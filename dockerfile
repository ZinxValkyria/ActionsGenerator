# Use the official Python image from the Docker Hub
FROM python:3.11

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# COPY .env /app/.env

# Copy the New Relic configuration file
 COPY newrelic.ini /app/newrelic.ini

# Copy the New Relic configuration file
COPY newrelic.ini /app/newrelic.ini


# Expose port 5000 for the Flask application
EXPOSE 5000

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
ENV NEW_RELIC_CONFIG_FILE=/app/newrelic.ini

# Run the Flask application using New Relic
CMD ["newrelic-admin", "run-program", "flask", "run"]
