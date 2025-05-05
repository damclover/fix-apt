#!/bin/bash

echo "===== Removing APT locks ====="
sudo rm -f /var/lib/apt/lists/lock
sudo rm -f /var/cache/apt/archives/lock
sudo rm -f /var/lib/dpkg/lock
sudo rm -f /var/lib/dpkg/lock-frontend

echo "===== Reconfiguring pending packages ====="
sudo dpkg --configure -a

echo "===== Fixing broken packages ====="
sudo apt --fix-broken install -y

echo "===== Cleaning and updating cache ====="
sudo apt clean
sudo apt autoclean
sudo apt update

echo "===== Removing corrupted package lists ====="
sudo rm -rf /var/lib/apt/lists/*
sudo mkdir -p /var/lib/apt/lists/partial
sudo apt update

echo "===== Verifying and configuring packages again ====="
sudo dpkg --audit
sudo dpkg --configure -a
sudo apt install -f -y

echo "===== Reinstalling base package management tools ====="
sudo apt install --reinstall dpkg apt -y

echo "===== Updating system ====="
sudo apt update
sudo apt upgrade -y

echo "===== Forcing missing package downloads (if necessary) ====="
sudo apt update --fix-missing

echo "===== Importing missing GPG key for Kali repositories ====="
curl -fsSL https://archive.kali.org/archive-key.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kali.gpg

echo "===== Adjusting permissions for APT lists ====="
sudo chown -R _apt:root /var/lib/apt/lists
sudo chmod -R 755 /var/lib/apt/lists

echo "===== APT reset successfully completed! ====="
