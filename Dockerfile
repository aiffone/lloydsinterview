# Use a Python base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt to the working directory
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire app directory into /app in the container
COPY app/. ./  # Copy all contents from the app directory to /app in the container

# Expose port 8080 for the app
EXPOSE 8080

# Command to run the app
CMD ["python", "app.py"]  # This assumes app.py is directly in /app
