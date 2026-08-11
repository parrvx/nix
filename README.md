# NixOS & Home Manager Configuration

This repository contains my personal, declarative system and dotfiles configuration built with Nix, Flakes, and `nixos-unified`. It is designed for a fast, keyboard-centric workflow featuring a Wayland-based tiling window manager and a cohesive Matrix-inspired aesthetic.
![wallpapper](https://github.com/parrvx/nix/blob/main/assets/wallpaper.jpg)

## ✨ Key Features

### 🖥️ Desktop & Window Management

* **Window Manager**: River WM (Wayland) using `rivertile` as the default layout.
* **Display Manager**: Ly Display Manager configured with a Matrix animation.
* **Launcher & Menus**: Fuzzel and `wlr-which-key` for dynamic, quick-access menus (Apps, Power, Modes, Rebuilds).
* **Notifications**: Mako, styled to match the system's dark/neon-green Matrix theme.
* **Terminal**: Foot terminal running with a custom "Terminal Mode" script to seamlessly manage `tmux` sessions.
* **Audio**: PipeWire with ALSA and PulseAudio compatibility. Volume is managed via `pulsemixer`.

### 🛠️ Core Utilities & Apps

* **Browser**: Highly customized Qutebrowser
* **Editor**: Fully declarative Neovim setup via NixVim, featuring the `cyberdream` theme, LSP (Rust, Nix, Haskell, Markdown), Telescope, Flash, Yazi, and Lazygit integration.
* **File Management**: Yazi terminal file manager integrated with `ffmpeg`, `p7zip`, `poppler`, `fzf`, `mpv` (video), `imv` (images), and `zathura` (PDFs).
* **Chat**: Iamb (Matrix client).
* **Office**: Gimp and LibreOffice.
* **System Management**: `nh` (Nix Helper) for clean and efficient rebuilds and garbage collection.

### 💻 Shell & Development

* **Shell Environment**: Bash and Zsh, supercharged with Starship prompt and Zoxide.
* **CLI Tools**: Modern utilities including `ripgrep`, `fd`, `sd`, `fzf`, `bat`, `jq`, and `btop`.
* **Environment management**: Direnv with `nix-direnv` for fast, automatic shell environment loading.
* **Git**: Declarative Git and Lazygit configuration.

## 📂 Repository Structure

The project follows the `nixos-unified` autowiring structure to organize modules and configurations.

```
.
├── assets/                 # Static files and auxiliary scripts
│   ├── scripts/
│   │   └── terminal.sh     # Script to toggle the "Terminal Mode" (Foot + Tmux)
│   ├── .envrc              # Direnv integration to automatically load the environment
│   └── wallpaper.jpg       # Matrix-themed wallpaper
├── configurations/
│   ├── home/               # User-specific Home Manager configurations
│   │   └── parrvx.nix      # Main configuration for the 'parrvx' user
│   └── nixos/
│       └── nixos/          # Host-based OS configurations
│           ├── configuration.nix         # Global system options (boot, network, sound, locale)
│           ├── default.nix               # System modules entry point
│           └── hardware-configuration.nix # Automatically generated hardware settings
├── modules/
│   ├── flake/              # Flake-level modules
│   │   ├── apps/           # Declarative app configurations (Neovim, Yazi, Qutebrowser, etc.)
│   │   ├── devshell.nix    # Development environment for working on the config (nixd, just)
│   │   └── toplevel.nix    # Flake wiring and formatter setup
│   ├── home/               # Home Manager modules and settings
│   │   ├── river/          # River WM config and its ecosystem (Foot, Fuzzel, Mako, keybinds)
│   │   ├── direnv.nix      # Direnv and nix-direnv settings
│   │   ├── gaming.nix      # Lutris, protonup...
│   │   ├── git.nix         # Git and Lazygit aliases and configuration
│   │   ├── packages.nix    # User packages and terminal tools (fzf, bat, btop)
│   │   ├── shell.nix       # Zsh, Bash, and Starship prompt configurations
│   │   ├── me.nix          # Global user identity variables (name, email)
│   │   └── nh.nix          # Nix Helper configuration and automatic garbage collection
│   └── nixos/              # System-level (NixOS) modules
│       ├── common/         # Shared settings, such as declarative user management
│       ├── gui/            # Desktop environment settings (River WM enablement, GDM/Gnome, fonts)
│       └── default.nix     # Imports main modules and enables SSH
├── flake.nix               # Main entry point with Nix dependencies and inputs definitions
├── flake.lock              # Lockfile pinning the exact versions of the flake dependencies
├── justfile                # Command runner tool for shortcuts (like `just run`, `just update`)
├── vira.hs                 # Configuration file for the CI (Continuous Integration) process
└── README.md               # Main documentation file for the repository```
```

## ⌨️ Custom Keybindings (`wlr-which-key`)

Using `wlr-which-key`, several modal menus are mapped to the `Super` key:

* **`Super + D` (Apps)**: Browser, Gimp, LibreOffice, Yazi, Neovim (Vault), Footclient, Iamb.
* **`Super + S` (System)**: Shutdown, Reboot, Volume.
* **`Super + M` (Modes)**: Terminal Mode (Tmux), Develop Mode, Legal Mode (PJeOffice), Volume.
* **`Super + N` (Nix)**: Rebuild system (`nh os switch`), Garbage Collection (`nh clean all`).

## 🚀 Getting Started

### Prerequisites

* [Nix](https://nixos.org/download.html) installed with `flakes` and `nix-command` experimental features enabled.
* [Just](https://github.com/casey/just) installed (optional, but recommended for easy commands).

### Manual Activation

To activate the configuration manually without `just`:
```bash
nix run
```
