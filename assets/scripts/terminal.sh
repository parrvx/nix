#!/usr/bin/env bash
# ==========================================
# Terminal Mode (k3r1n9) - Toggle Script
# ==========================================
set -euo pipefail

if pgrep -f "foot --server" >/dev/null; then
  # --- TURN OFF ---
  pkill -f "footclient tmux" 2>/dev/null || true
  pkill -f "foot --server" 2>/dev/null || true

  notify-send "Terminal Mode" "Disabled"
else
  # --- TURN ON ---
  nohup foot --server >/dev/null 2>&1 &
  sleep 0.2
  nohup footclient tmux new-session -A -s k3r1n9 >/dev/null 2>&1 &

  notify-send "Terminal Mode" "Enabled (Tmux)"
fi
