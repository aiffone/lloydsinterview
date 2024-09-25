# Use a Python base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt  # Use --no-cache-dir to reduce image size

# Copy the rest of the app files
COPY . .  # This copies everything from the current directory to /app

# Expose port 8080 for the app
EXPOSE 8080

# Command to run the app
CMD ["python", "app.py"]  # Ensure app.py exists in the root of the working directory
