# Use a Python base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt to the working directory and install dependencies
COPY requirements.txt /app/  # Specify the absolute path to the WORKDIR
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files to the working directory
COPY . /app/  # Specify the absolute path to the WORKDIR

# Expose port 8080 for the app
EXPOSE 8080

# Command to run the app using JSON array format
CMD ["python", "app.py"]
