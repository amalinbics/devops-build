#!/bin/bash

set -e

echo "📦 Installing dependencies..."
sudo apt-get install -y apt-transport-https software-properties-common wget

echo "🔑 Adding Grafana GPG key..."
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

echo "📁 Adding Grafana APT repository..."
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

echo "🔄 Updating package list..."
sudo apt-get update

echo "🚀 Installing Grafana..."
sudo apt-get install -y grafana

echo "🛠️ Starting and enabling Grafana service..."
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

echo "✅ Grafana installation complete!"
echo "🌐 Access Grafana at: http://<your-server-ip>:3000"