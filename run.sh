#!/bin/bash

# Prompt the user for their GitHub PAT
echo "Enter your GitHub Personal Access Token (PAT):"
read -s pat
echo ""

# Clone the model-training repository into a subdirectory using the PAT
git clone https://username:$pat@github.com/remla24-team-1/model-training.git ../model-training

# Build and start the services using docker-compose
docker-compose build
docker-compose up