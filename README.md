# NixOS & Home Manager Configuration

This repository contains my declarative, reproducible personal system and dotfiles configuration built with Nix, Flakes, and `nixos-unified`. It is tailored for a fast, keyboard-centric workflow featuring the River Wayland tiling window manager, a cohesive Matrix visual scheme, and secret management integrated with `sops-nix` and `passage`.

## Key Features

### Desktop & Window Management

* **Window Manager**: River WM (Wayland) using `rivertile` as the dynamic layout generator.
* **Display Manager**: Ly Display Manager configured with an active Matrix background animation.
* **Launcher & Menus**: Fuzzel for dynamic program execution and `wlr-which-key` for contextual keybindings and submenus (Apps, System, Modes, Games, Nix).
* **Keyboard Remapping**: Kanata daemon driving custom modal keymaps (CapsLock modifiers, navigation, and a dedicated Numpad layer).
* **Notifications**: Mako notification daemon styled in dark/neon-green.
* **Terminal Suite**: Foot terminal emulator running `tmux` by default. Includes a custom toggle script (`terminal.sh`) for headless client/server terminal mode.
* **Audio & Media**: PipeWire with ALSA/PulseAudio emulation managed via `pulsemixer`, with custom `mpv` streaming rules.

### Core Applications & Secrets

* **Text Editor**: Custom Helix package bundled with language servers (`zk`, `nil`, `pyright`, `rust-analyzer`, `bash-language-server`).
* **File Management**: Yazi terminal file manager integrated with `ffmpeg`, `poppler`, `p7zip`, `fzf`, `lazygit`, `zk`, `mpv`, `imv`, and `zathura`.
* **Browsers**: Firefox (configured with dark mode enforcement, low-RAM optimizations, uBlock Origin, and custom `userChrome.css`) and Chromium.
* **Secrets & Passwords**: `sops-nix` with Age key encryption for system secrets, coupled with `passage` and a custom Fuzzel/Dmenu password picker (`passage-menu`).
* **Smart Glasses Integration**: Background systemd user service executing `@evenrealities/even-terminal` for the Even Realities G2 glasses powered by Claude AI.

### Development & System Utilities

* **Nix Implementation**: Powered by `lix` package manager for fast evaluation.
* **Shell Environment**: Bash extended with `carapace` auto-completion, `zoxide` directory navigation, `fzf`, and modern Rust CLI tools (`eza`, `dust`, `procs`, `delta`, `hyperfine`, `sd`, `ripgrep`, `fd`, `ouch`).
* **Modular DevShells**:
* **Config Shell**: Built-in native scripts (`flake-update`, `flake-lint`, `flake-check`, `flake-run`, `flake-help`).
* **Python**: Pre-configured with Polars, DuckDB, Quarto, Node.js, and Evidence template support.
* **Rust**: Toolchain including `cargo`, `rustc`, `rust-analyzer`, `clippy`, and `rustfmt`.
* **WoW Server**: Native build toolchain for AzerothCore (WotLK) compilation.
* **Virtualization & Gaming**: KVM/libvirtd with SPICE USB redirection, `virt-manager`, `quickemu`, Docker, Steam/Lutris, and Linux Zen Kernel with GameMode.
* **Nix Helper**: `nh` tool for streamlined system rebuilds and automated garbage collection.

## Repository Structure

The layout adheres to `nixos-unified` autowiring patterns to organize system and user configurations:

```text
.
├── assets/                 # Wallpaper image and helper scripts
│   └── scripts/
│       └── terminal.sh     # Script to toggle Foot server/client headless mode
├── configurations/         # System and target machine definitions
│   ├── nixos/s145/         # Host-specific NixOS configuration (Lenovo S145)
│   ├── nix-on-droid/droid/ # Android/Termux configuration via nix-on-droid
│   └── user/parrvx.nix     # User identity and sops settings
├── modules/
│   ├── flake/              # Flake outputs, wrappers, and devShells
│   │   ├── apps/           # Custom program wrappers (Helix, Yazi, Zathura, Iamb)
│   │   └── develop/        # Modular devShells (Python, Rust, AzerothCore, Shell)
│   ├── home/               # Home Manager modules
│   │   ├── river/          # River WM setup (fuzzel, foot, mako, wlr-which-key)
│   │   ├── even.nix        # Even Realities G2 Glasses service
│   │   ├── firefox.nix     # Customized Firefox browser profile
│   │   └── packages.nix    # User-level CLI and GUI packages
│   └── nixos/              # System-level NixOS modules
│       ├── common/         # Tailscale, virtualization, and user options
│       └── gui/            # River WM, Ly DM, and Kanata keymapping
├── secrets/                # SOPS encrypted yaml files
├── flake.nix               # Entry point defining inputs and systems
├── flake.lock              # Dependency lockfile
└── justfile                # Shortcut command runner
```

## Custom Keybindings (`wlr-which-key`)

Press `Super + Key` to open contextual modal menus:

* **`Super + D` (Apps)**: Launch Gaming (`lutris`), LibreOffice, File Manager (`yazi`), Notes (`helix`), Terminal (`tmux`), Matrix Client (`iamb`).
* **`Super + S` (System)**: Poweroff, Reboot, Process Monitor (`bottom`), Volume (`pulsemixer`).
* **`Super + M` (Modes)**: Toggle Terminal Mode, Enter Config DevShell, Even G2 Glasses Terminal, Legal Mode (PJeOffice).
* **`Super + G` (Games & Web)**: Factorio, Google Chrome.
* **`Super + N` (Nix)**: Test Flake (`nix flake check`), System Switch (`nh os switch`), Garbage Collector (`nh clean all`).

## Getting Started

### Prerequisites

* Nix with `flakes` and `nix-command` experimental features enabled.
* `sops` and `age` installed if decrypting system secrets.

### Workflow Commands

You can use `just` commands or the custom native shell helpers:

| Action | Native Script | Just Command | Standard Nix Command |
| --- | --- | --- | --- |
| **Enter DevShell** | `nix develop` | `just dev` | `nix develop` |
| **Update Inputs** | `flake-update` | `just update` | `nix flake update` |
| **Format Code** | `flake-lint` | `just lint` | `nix fmt` |
| **Validate Flake** | `flake-check` | `just check` | `nix flake check` |
| **Apply System** | `flake-run` | `just run` | `nix run` |
| **View Help** | `flake-help` | `just` | — |
