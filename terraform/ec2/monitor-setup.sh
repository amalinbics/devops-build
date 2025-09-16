#!/bin/bash

set -e

PROM_VERSION="2.43.0"
PROM_USER="prometheus"
PROM_GROUP="prometheus"
PROM_DIR="/etc/prometheus"
PROM_DATA_DIR="/var/lib/prometheus"
PROM_BIN_DIR="/usr/local/bin"
PROM_SERVICE="/etc/systemd/system/prometheus.service"

echo "🔧 Creating Prometheus user and group..."
sudo groupadd --system $PROM_GROUP || true
sudo useradd -s /sbin/nologin --system -g $PROM_GROUP $PROM_USER || true

echo "📁 Creating directories..."
sudo mkdir -p $PROM_DIR $PROM_DATA_DIR
sudo chown $PROM_USER:$PROM_GROUP $PROM_DIR $PROM_DATA_DIR

echo "📦 Downloading Prometheus $PROM_VERSION..."
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar -xvf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
cd prometheus-${PROM_VERSION}.linux-amd64

echo "🚚 Moving binaries..."
sudo mv prometheus promtool $PROM_BIN_DIR
sudo chown $PROM_USER:$PROM_GROUP $PROM_BIN_DIR/prometheus $PROM_BIN_DIR/promtool

echo "📝 Setting up configuration..."
sudo mv prometheus.yml $PROM_DIR/
sudo mv consoles console_libraries $PROM_DIR/
sudo chown -R $PROM_USER:$PROM_GROUP $PROM_DIR

echo "🛠️ Creating systemd service..."
cat <<EOF | sudo tee $PROM_SERVICE
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=$PROM_USER
Group=$PROM_GROUP
Type=simple
ExecStart=$PROM_BIN_DIR/prometheus \\
  --config.file=$PROM_DIR/prometheus.yml \\
  --storage.tsdb.path=$PROM_DATA_DIR \\
  --web.console.templates=$PROM_DIR/consoles \\
  --web.console.libraries=$PROM_DIR/console_libraries

[Install]
WantedBy=multi-user.target
EOF

echo "🚀 Starting Prometheus..."
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

echo "✅ Prometheus installation complete!"
echo "🌐 Access Prometheus at: http://<your-server-ip>:9090"