#!/usr/bin/env bash
set -euo pipefail

if systemctl is-active --quiet grafana; then
  sudo systemctl stop grafana prometheus prometheus-node-exporter
  notify-send "Metrics: Desabled"
else
  if [ -f /run/secrets/grafana_secret_key ]; then
    sudo chmod 644 /run/secrets/grafana_secret_key
  fi
  sudo systemctl start prometheus-node-exporter prometheus grafana
  notify-send "Metrics: Enabled"
fi
