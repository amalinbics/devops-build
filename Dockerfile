# Use official Nginx image
FROM nginx:alpine

# Remove default Nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d

# Copy React build files to Nginx web root
COPY build/ /usr/share/nginx/html

# Expose port 3000
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]