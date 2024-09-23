# lloydsinterview/Dockerfile
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY app/ /app

# Install any needed packages
RUN pip install flask

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the application
CMD ["python", "main.py"]
