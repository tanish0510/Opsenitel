# Use an official lightweight Bash base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    bash \
    nginx \
    curl \
    cron \
    findutils \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Copy scripts and HTML dashboard
COPY maintain.sh /usr/local/bin/maintain.sh
COPY public/index.html /var/www/html/index.html

# Make script executable
RUN chmod +x /usr/local/bin/maintain.sh

# Setup CRON job
RUN echo "0 2 * * * /usr/local/bin/maintain.sh >> /var/log/maintain.log 2>&1" > /etc/cron.d/ops-cron \
    && chmod 0644 /etc/cron.d/ops-cron \
    && crontab /etc/cron.d/ops-cron

# Expose HTTP port
EXPOSE 80

# Start both NGINX and CRON
CMD service cron start && nginx -g "daemon off;"
