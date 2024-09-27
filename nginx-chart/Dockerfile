# Use the official NGINX image as a base
FROM nginx:latest

# Copy your custom configuration file (if you have one)
# ADD ./nginx.conf /etc/nginx/nginx.conf

# Copy static files (optional)
# COPY ./html /usr/share/nginx/html

# Expose the port
EXPOSE 80

# Command to run NGINX (optional, the default command is already set in the base image)
CMD ["nginx", "-g", "daemon off;"]
