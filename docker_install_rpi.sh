#!/bin/bash

# Update and upgrade the system packages
echo "Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker repository
echo "Setting up Docker repository..."
echo "deb [arch=armhf signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/raspbian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package information again
echo "Updating package information..."
sudo apt-get update -y

# Install Docker
echo "Installing Docker..."
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Verify Docker installation
echo "Verifying Docker installation..."
sudo docker --version

# Add your user to the Docker group
echo "Adding user to the Docker group..."
sudo usermod -aG docker ${USER}

# Reboot to apply changes
echo "Docker installed successfully! Rebooting system..."
sudo reboot
