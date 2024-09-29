# Use a Python base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt to the working directory
COPY hello-world/app/requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --upgrade Flask

# Copy the entire app directory into /app in the container
COPY hello-world/app/app.py /app/

# Expose port 8080 for the app
EXPOSE 8080

# Command to run the app and keep the container alive for 5 minutes
CMD ["sh", "-c", "python3 app.py & sleep 300"]
