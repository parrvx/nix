#!/usr/bin/env bash
# ==========================================
# Terminal Mode (k3r1n9) - Toggle Script
# ==========================================
set -euo pipefail

if pgrep -f "foot --server" > /dev/null; then
    # --- TURN OFF ---
<<<<<<< HEAD
    # Mata o servidor e o tmux de forma limpa
=======
    # Gracefully terminate the server and the associated tmux session
>>>>>>> 1705b6d (virtualization)
    pkill -f "footclient tmux" 2>/dev/null || true
    pkill -f "foot --server" 2>/dev/null || true
    
    notify-send "Terminal Mode" "Disabled"
else
    # --- TURN ON ---
<<<<<<< HEAD
    # Inicia o servidor em segundo plano totalmente desvinculado
    nohup foot --server >/dev/null 2>&1 &
    
    # Aguarda o socket do foot responder antes de tentar o client
    sleep 0.2
    
    # Executa o client desvinculado
=======
    # Start the server in the background as a detached process
    nohup foot --server >/dev/null 2>&1 &
    
    # Wait for the foot socket to become responsive before spawning the client
    sleep 0.2
    
    # Run the detached client attached to tmux
>>>>>>> 1705b6d (virtualization)
    nohup footclient tmux new-session -A -s k3r1n9 >/dev/null 2>&1 &
    
    notify-send "Terminal Mode" "Enabled (Tmux)"
fi
