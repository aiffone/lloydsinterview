# Use a Python base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt to the working directory
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire app directory into /app in the container
COPY app/ ./  # This copies everything from app directory into /app

# Expose port 8080 for the app
EXPOSE 8080

# Command to run the app (using the full path to python3)
CMD ["/usr/local/bin/python3", "app.py"] 
