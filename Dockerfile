# Use the official Nginx image from Docker Hub
FROM nginx:alpine

# Copy custom Nginx configuration file to the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the HTML file and the jsdos file to the Nginx HTML directory
COPY index.html /usr/share/nginx/html/
COPY turbo-pascal.jsdos /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx when the container has provisioned
CMD ["nginx", "-g", "daemon off;"]