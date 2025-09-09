#!/bin/bash
sudo apt update -y 
# Download the installer
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

sudo apt install unzip -y

# Unzip the package
unzip awscliv2.zip

# Run the installer
sudo ./aws/install

# Verify installation
aws --version

# Clean up
rm -rf awscliv2.zip aws