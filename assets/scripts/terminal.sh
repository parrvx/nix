#!/usr/bin/env bash
# ==========================================
# Terminal Mode (k3r1n9) - Toggle
# ==========================================
# Check if the Foot server is already running
if pgrep -f "foot --server" > /dev/null; then
    # --- TURN OFF ---
         
    # Terminate the graphical server (closes the window visually)
    pkill -f "foot --server"
         
    # Terminate the Tmux server (kills the sessions)
    # Important: This ensures that 'checkhealth' and background processes don't consume RAM.
    pkill -f "tmux"
    notify-send "Terminal Mode" "Disabled"
else
    # --- TURN ON ---
         
    # Start the Foot server in the background
    foot --server &
         
    # Technical pause (0.2s) to ensure the server socket is successfully created
    sleep 0.2
          
    # Open footclient running Tmux
    # 'new-session -A -s k3r1n9': 
    # 1. '-s k3r1n9': Names the session "k3r1n9".
    # 2. '-A': If session "k3r1n9" already exists (running in background), attach to it. If not, create a new one.
    # footclient tmux new-session -A -s k3r1n9 &
         
    notify-send "Terminal Mode" "Enabled (Tmux)"
fi
