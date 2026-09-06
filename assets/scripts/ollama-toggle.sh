#!/usr/bin/env bash
set -euo pipefail

if pgrep -x "ollama" >/dev/null; then
  pkill -x "ollama" 2>/dev/null || true
  notify-send "Ollama" "Service Disabled"
else
  nohup ollama serve >/dev/null 2>&1 &
  notify-send "Ollama" "Service Enabled"
fi
