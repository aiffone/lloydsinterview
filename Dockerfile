# Use a Python base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy the rest of the app files
COPY . .

# Expose port 8080 for the app
EXPOSE 8080

# Command to run the app
CMD ["python", "app.py"]
