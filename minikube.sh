# Shell script for minikube installation

#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

# Function to print success message
function success_message {
    echo -e "\n\033[0;32m$1\033[0m"
}

# Function to print error message
function error_message {
    echo -e "\n\033[0;31m$1\033[0m"
}

# Step 1: Update the system and install prerequisites
echo "Updating system and installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y curl apt-transport-https

# Step 2: Install Minikube
echo "Installing Minikube..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube /usr/local/bin/

# Step 3: Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Step 4: Verify Minikube and kubectl installation
echo "Verifying Minikube installation..."
minikube version

if [ $? -eq 0 ]; then
    success_message "Minikube installed successfully."
else
    error_message "Minikube installation failed."
    exit 1
fi

echo "Verifying kubectl installation..."
kubectl version --client

if [ $? -eq 0 ]; then
    success_message "kubectl installed successfully."
else
    error_message "kubectl installation failed."
    exit 1
fi

# Step 5: Start Minikube
echo "Starting Minikube with Docker driver..."
minikube start --driver=docker

if [ $? -eq 0 ]; then
    success_message "Minikube started successfully."
else
    error_message "Failed to start Minikube."
    exit 1
fi

# Step 6: Check Minikube status
echo "Checking Minikube status..."
minikube status

# Cleanup: Remove the downloaded Minikube binary
rm minikube

success_message "Minikube setup completed successfully!"
