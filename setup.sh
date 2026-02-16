#!/bin/bash

echo "Updating system..."
sudo apt update

echo "Installing Python tools..."
sudo apt install python3-venv python3-pip -y

echo "Creating virtual environment..."
python3 -m venv ansible215

echo "Activating environment..."
source ansible215/bin/activate

echo "Installing Ansible 2.15..."
pip install --upgrade pip
pip install ansible-core==2.15.12

echo "Done."
echo "To activate later run:"
echo "source ansible215/bin/activate"
