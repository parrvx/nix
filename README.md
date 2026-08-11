# NixOS & Home Manager Configuration

This repository contains my personal, declarative system and dotfiles configuration built with Nix, Flakes, and `nixos-unified`. It is optimized for a fast, keyboard-centric workflow featuring a Wayland-based tiling window manager and a cohesive Matrix-inspired visual identity.

![wallpaper](assets/wallpaper.jpg)

## Key Features

### Desktop & Window Management

* **Window Manager**: River WM (Wayland) running `rivertile` as the default layout generator.
* **Display Manager**: Ly Display Manager configured with a Matrix animation.
* **Launcher & Keymaps**: Fuzzel for application launching and `wlr-which-key` for contextual modal menus (Apps, System, Modes, Games, Nix).
* **Keyboard Remapping**: Kanata daemon for custom modal layers (CapsLock modifiers and dedicated Numpad layer).
* **Notifications**: Mako, styled to match the dark/neon-green Matrix visual scheme.
* **Terminal Environment**: Foot terminal emulator configured with Nushell as the default interactive shell, integrated with Zellij multiplexer.
* **Audio**: PipeWire with ALSA and PulseAudio compatibility, managed via `pulsemixer`.

### Core Utilities & Applications

* **Browser**: Customized Qutebrowser with custom keybindings and dark mode enforcement.
* **Editor**: Helix editor bundled with LSPs (`zk`, `nil`, `marksman`, `pyright`, `rust-analyzer`, `bash-language-server`).
* **File Management**: Yazi terminal file manager integrated with `ffmpeg`, `p7zip`, `poppler`, `fzf`, `lazygit`, `zk`, `mpv`, `imv`, and `zathura`.
* **Chat**: Iamb (Matrix client).
* **Office & Productivity**: LibreOffice, GIMP, Audacity, and Zathura (PDF viewer).
* **System Helper**: `nh` (Nix Helper) for clean rebuilds and automated garbage collection.

### Development & Environments

* **Shell Environment**: Nushell (default shell) with `zoxide` integration for fast directory navigation.
* **Development Shells**: Modular Nix devShells including:
  * **Python**: Polars, DuckDB, Quarto, Node.js, and Evidence template support.
  * **Rust**: Toolchain featuring `cargo`, `rustc`, `rust-analyzer`, `clippy`, and `rustfmt`.
  * **WoW Server**: Native build environment for compiling AzerothCore (WotLK).
  * **Config DevShell**: Custom automation scripts (`flake-update`, `flake-lint`, `flake-check`, `flake-run`, `flake-help`).
* **CLI Utilities**: Modern tools including `ripgrep`, `fd`, `sd`, `bat`, `jq`, `btop`, `tmate`, `jujutsu`, `aichat`, and `zk`.
* **Environment Automation**: Direnv paired with `nix-direnv` for automatic shell loading.

## Repository Structure

The project follows the `nixos-unified` autowiring structure to organize system and user configurations:

```text
.
├── assets/                 # Static assets and scripts
│   ├── scripts/
│   │   └── terminal.sh     # Script to toggle Terminal Mode (Foot + Tmux)
│   └── wallpaper.jpg       # Matrix-themed wallpaper
├── configurations/
│   ├── home/
│   │   └── parrvx.nix      # Main Home Manager user configuration
│   └── nixos/
│       └── nixos/          # Host-specific NixOS configuration
│           ├── configuration.nix
│           ├── default.nix
│           └── hardware-configuration.nix
├── modules/
│   ├── flake/              # Flake-level modules and devShells
│   │   ├── apps/           # Standalone package wrappers (Helix, Yazi, Qutebrowser, etc.)
│   │   ├── develop/        # Modular devShells (Python, Rust, WoW Server, DevShell)
│   │   └── toplevel.nix    # Flake integration and formatter definitions
│   ├── home/               # Home Manager modules
│   │   ├── river/          # River WM configuration ecosystem (Foot, Fuzzel, Mako, River, WLR)
│   │   ├── direnv.nix      # Direnv and nix-direnv configuration
│   │   ├── gaming.nix      # Gaming tools (Lutris, ProtonUp-Qt, Winetricks)
│   │   ├── git.nix         # Declarative Git and Lazygit configuration
│   │   ├── nh.nix          # Nix Helper and automatic garbage collection settings
│   │   ├── packages.nix    # User CLI and GUI package declarations
│   │   ├── shell.nix       # Nushell, Zellij, and Zoxide configurations
│   │   └── ...             # Other user modules (mime, ssh, chromium, office, etc.)
│   └── nixos/              # System-level (NixOS) modules
│       ├── common/         # Shared user management settings
│       ├── gui/            # Display server, Kanata, and WM options
│       └── default.nix     # Core system options (zRam, GPU drivers, MySQL, Docker)
├── flake.nix               # Main entry point with Nix inputs and system definitions
├── flake.lock              # Lockfile pinning exact flake dependencies
└── justfile                # Command runner shortcuts
```

## Custom Keybindings (`wlr-which-key`)

Press `Super` along with the prefix key to bring up modal access menus:

* **`Super + D` (Apps)**: Gaming (Lutris), LibreOffice, Find (Yazi), Note (Helix), Terminal (Zellij), Matrix (Iamb).
* **`Super + S` (System)**: Shutdown, Reboot, Btop, Volume (`pulsemixer`).
* **`Super + M` (Modes)**: Terminal Mode, Develop Mode, Even G2 Terminal, Legal Mode (PJeOffice), Volume.
* **`Super + G` (Games & Web)**: Factorio, Google Chrome.
* **`Super + N` (Nix)**: Test Flake (`nix flake check`), Rebuild (`nh os switch`), Garbage Collection (`nh clean all`).

## Getting Started

### Prerequisites

* [Nix](https://nixos.org/download.html) installed with `flakes` and `nix-command` experimental features enabled.

### Quick Commands

You can use the built-in development environment automation or standard `nix` commands:

* **Enter DevShell**:

```bash
nix develop
```

* **Update Flake Inputs**:

```bash
flake-update  # or `nix flake update`
```

* **Format Configuration Files**:

```bash
flake-lint    # or `nix fmt`
```

* **Validate Flake**:

```bash
flake-check   # or `nix flake check`
```

* **Apply Configuration**:

```bash
flake-run     # or `nix run`
```

