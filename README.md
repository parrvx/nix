# Nix

A declarative, reproducible personal workstation and cross-platform configuration managed with **Nix Flakes**, **`nixos-unified`**, and **Home Manager**.

Engineered for a lightweight, keyboard-driven Wayland environment styled in an aesthetic Matrix-green terminal theme, featuring secret management via `sops-nix` and `passage`, custom-wrapped standalone packages, dynamic modal keybindings via `wlr-which-key` and `kanata`, headless workstation toggles, and multi-target deployments (NixOS, Nix-on-Droid / Termux).

![Wallpaper](assets/wallpaper.jpg)

---

## Architecture & Design Highlights

* **Flake Architecture**: Built on [`flake-parts`](https://flake.parts/) and [`nixos-unified`](https://nixos-unified.org/) autowiring conventions for system configurations, Home Manager profiles, wrappers, and modular devshells.
* **Nix Package Manager**: Powered by [`Lix`](https://lix.systems/) for fast, robust flake evaluation and builds.
* **Unified Secrets Pipeline**: Full encryption at rest using Age keys with [`sops-nix`](https://github.com/Mic92/sops-nix) for both NixOS system-level and Home Manager user-level secrets, integrated with [`passage`](https://github.com/FiloSottile/passage) and dynamic fuzzel dmenu menus.
* **Cross-Target Compatibility**:
  * **NixOS (`s145`)**: Lenovo IdeaPad S145 target (`x86_64-linux`), custom kernel optimizations, hardware virtualization, and Wayland desktop.
  * **Nix-on-Droid (`droid`)**: Android / Termux declarative CLI runtime environment (`release-24.05`).
  * **nix-darwin**: Prepared input wiring for macOS targets.

---

## System Overview & Features

### Desktop & Window Management (Wayland)
* **Window Manager**: **River** (`river-classic` with pure Wayland, `xwayland.enable = false`) driven by `rivertile` (zero padding, bottom attach mode, hidden typing cursor, dynamic ratio/layout controls).
* **Display Manager**: **Ly** console display manager with real-time `matrix` background animation.
* **Key Remapping**: **Kanata** hardware daemon (`services.kanata`) configuring the `matrix-input` keyboard:
  * Tap `Caps Lock` for `Esc`; hold for the `mods` layer.
  * Modal numeric numpad layer and direct layer switches.
* **Application Launcher & Dmenu**: **Fuzzel** styled with high-contrast neon green (`#39ff14ff`) accents and overlays.
* **Contextual Menu Daemon**: **`wlr-which-key`** mapped to `Super + <Key>` chords for modal system, app, and mode actions.
* **Notifications**: **Mako** notification daemon configured with JetBrains Mono, 7px rounded corners, and Matrix neon borders.
* **Screen Utilities**: `grim` + `slurp` for selective region screenshots into `wl-clipboard`, `wlr-randr`, and `brightnessctl`.

### Terminal Suite & Shell Environment
* **Terminal Emulator**: **Foot** styled with pure black background (`#000000`), white foreground (`#ffffff`), and JetBrains Mono Nerd Font.
* **Headless Client/Server Mode**: Custom script (`assets/scripts/terminal.sh`) toggling Foot background daemon mode and attaching/detaching persistent `tmux` sessions.
* **Multiplexer (`tmux`)**: Configured with 24-hour clock, Vi mode keys, top status line in pure black/matrix-green, and 256-color TrueColor support.
* **Shell & Utilities**: Bash configured with:
  * **Carapace**: Multi-shell completion engine across bash, zsh, and nushell.
  * **Zoxide**: Fast directory jumper (`z`).
  * **FZF**: Fuzzy finding integrations and bindings.
  * **Modern CLI Tools**: `dust`, `delta`, `bandwhich`, `hyperfine`, `onefetch`, `sd`, `ouch`, `ripgrep`, `fd`, `bat`, `jq`, `bottom` (`btm`), and `tmate`.
  * **nix-index**: Automated command-not-found database and `comma` (`nix-index-database.comma`).
  * **Direnv**: Fast environment reloading via `nix-direnv` with suppressed diff noise.

### Custom Packaged Standalone Wrappers (`modules/flake/apps/`)
To preserve store reproducibility while isolating application configs and dependencies, standalone wrappers are generated via `pkgs.symlinkJoin` and `wrapProgram`:
* **`myhelix`**: Wrapped `hx` bundling `ayu_evolve` theme, relative line numbers, soft wrapping, and integrated LSPs on `$PATH`: `markdown-oxide`, `nil`, `pyright`, `rust-analyzer`, and `bash-language-server`.
* **`myyazi`**: Wrapped terminal file manager with custom 1:2:5 column ratios, native openers for Helix, MPV, IMV, and Sioyek, plus isolated runtime tool dependencies (`ffmpeg`, `p7zip`, `poppler`, `fd`, `ripgrep`, `fzf`, `lazygit`, `zk`, `mpv`, `imv`, `sioyek`). Includes custom keybindings for Git (`g i`), zk Vault (`g z`), and note management.
* **`mysioyek`**: Customized PDF viewer wrapping keymaps (`J`/`K` navigation) and default dark mode.
* **`myiamb`**: Matrix chat client wrapper with pre-generated configuration for Matrix profiles.

### Networking, Tunnels & Dynamic DNS
* **Tailscale**: Enabled with trusted interface rules (`tailscale0`) and custom UDP firewall allocation (`41641`).
* **WireGuard (`wg0`)**: Native interface listening on UDP `51820` authenticated via SOPS secrets (`wireguard_private_key`), paired with remote mobile endpoints.
* **DuckDNS Service**: Automated systemd timer running every 5 minutes (`duckdns.timer`) executing dynamic DNS cURL updates using encrypted SOPS tokens.
* **Mosh & Remote Work**: Mosh daemon enabled with auto-opened UDP ports `60000-61000`, along with `waypipe` for remote Wayland application forwarding.

### Kernel, Virtualization & Gaming
* **Kernel & Memory**:
  * **Linux Zen Kernel** (`linuxPackages_zen`) for low-latency desktop responsiveness.
  * **ZRAM Swap**: 100% RAM allocation compressed with `zstd`.
  * Dedicated 8GB secondary `/var/lib/swapfile` and tuned `sysctl` dirty writeback thresholds (`vm.dirty_ratio = 10`, `vm.dirty_background_ratio = 5`).
* **Graphics Acceleration**: AMD GPU Mesa RADV with 32-bit Vulkan support and `gamemode` CPU governor optimization.
* **Virtualization**:
  * QEMU/KVM with `libvirtd`, `swtpm` (Software TPM 2.0 emulation for Windows 11 guest support), and SPICE USB device redirection.
  * Pre-installed utilities: `virt-manager`, `quickemu`, `spice-gtk`, and `usbredir`.
  * Docker with automated weekly pruning.
* **Gaming**: Steam (with open firewall for Remote Play and Dedicated Server), Lutris, `protonup-qt`, `winetricks`, `vkd3d`, and `gamescope`.

### AI, Smart Glasses & Background Services
* **Even Realities G2 Glasses**: Native systemd user service (`even-terminal.service`) running `@evenrealities/even-terminal` targeting a local OpenAI-compatible endpoint.
* **Local LLM (Ollama)**: Bundled with ROCm acceleration support (`ollama-rocm`), toggleable on demand via `assets/scripts/ollama-toggle.sh`.
* **Telemetry & Metrics Stack**: Prometheus + Prometheus Node Exporter + Grafana with encrypted secret key management, toggleable on demand via `assets/scripts/metrics-toggle.sh`.

### Web Browsers
* **Firefox & LibreWolf Profiles**:
  * Hardened and optimized for low memory footprint (`dom.ipc.processCount = 1`, isolated Web processes, tab unloading under low RAM, hardware video decoding).
  * Enforced dark theme override.
  * Disabled telemetry, Pocket, sponsored snippets, and Picture-in-Picture clutter.
  * Custom compact `userChrome.css` hiding the tab bar and compressing navigation height down to 22–28px.
  * Pre-configured extensions including uBlock Origin and Vimium C.
* **Chromium**: Configured with `--process-per-site`, disabled background networking, and Widevine DRM support.

---

## Modal Keybindings (`wlr-which-key`)

Press `Super + <Key>` inside River to trigger on-screen contextual action menus:

| Chord | Menu Category | Key | Action / Target Command |
|---|---|---|---|
| `Super + D` | **Apps** | `g` | Gaming (`lutris`) |
| | | `o` | LibreOffice (`libreoffice`) |
| | | `f` | File Manager (`foot -e yazi`) |
| | | `n` | Vault Notes (`foot bash -c 'cd ~/zk; vim .'`) |
| | | `t` | Main Terminal Session (`foot tmux new-session -A -s main`) |
| | | `m` | Matrix Client (`foot -e iamb`) |
| `Super + S` | **System** | `d` | Shutdown (`systemctl poweroff`) |
| | | `r` | Reboot (`systemctl reboot`) |
| | | `s` | Suspend (`systemctl suspend`) |
| | | `h` | Hibernate (`systemctl hibernate`) |
| | | `t` | Process Monitor (`foot -e btm`) |
| | | `v` | Audio Mixer (`foot pulsemixer`) |
| `Super + M` | **Modes** | `t` | Toggle Terminal Mode (Headless Foot server + tmux session) |
| | | `d` | Development Mode (Enter Flake DevShell in `~/zk/project`) |
| | | `o` | Toggle Ollama Service (`ollama-toggle.sh`) |
| | | `e` | Toggle Even Realities G2 Terminal Service |
| | | `l` | Legal Workplace Mode (`steam-run pjeoffice-pro.sh`) |
| | | `g` | Toggle Prometheus & Grafana Stack (`metrics-toggle.sh`) |
| | | `v` | Audio Mixer (`foot pulsemixer`) |
| `Super + G` | **Games & Web** | `f` | Factorio via Lutris (`lutris:rungameid/4`) |
| | | `d` | Door Kickers (`start-nix.sh`) |
| | | `c` | Chromium Browser (`chromium`) |
| `Super + N` | **Nix Maintenance** | `t` | Validate Flake (`foot -e nix flake check`) |
| | | `r` | Rebuild NixOS (`foot -e nh os switch ~/nix`) |
| | | `c` | Empty Trash & Garbage Collect (`nh clean all`) |

### Additional Global River Bindings
* **Launchers**: `Super + X` (Fuzzel), `Super + W` (Firefox), `Super + Shift + Return` (Foot), `Super + Shift + P` (`passage-menu`).
* **Window Control**: `Super + C` (Close window), `Super + J` / `Super + K` (Focus next/previous), `Super + Shift + J` / `K` (Swap window), `Super + Return` (Zoom main).
* **Tile Ratio & Orientation**: `Super + H` / `L` (Ratio adjustment), `Super + Arrow Keys` (Move layout direction top/right/bottom/left).
* **Screenshots**: `Super + Shift + S` (Interactive `grim -g "$(slurp)" - | wl-copy`).
* **Passthrough Mode**: `Super + F11` (Toggle River passthrough mode for nested VMs or games).

---

## Repository Structure

The repository follows a clean, modular structure wired together by `nixos-unified`:

```text
├── flake.nix                       # Flake entry point & module wiring
├── flake.lock                      # Flake inputs lockfile
├── justfile                        # Convenience recipe runner
├── .sops.yaml                      # Sops-nix Age key encryption rules
├── assets/
│   ├── wallpaper.jpg               # System desktop wallpaper
│   └── scripts/
│       ├── install.sh              # Automated NixOS disk partitioner & installer
│       ├── terminal.sh             # Foot server + tmux daemon toggle script
│       ├── ollama-toggle.sh        # Background Ollama toggle
│       └── metrics-toggle.sh       # Prometheus/Grafana monitoring toggle
├── configurations/
│   ├── nixos/
│   │   └── s145/                   # Lenovo IdeaPad S145 NixOS host
│   │       ├── configuration.nix   # Host base configuration, PipeWire, users & sudo
│   │       ├── hardware-configuration.nix
│   │       ├── bootloader.nix      # systemd-boot & EFI configuration
│   │       ├── tweaks.nix          # Zen kernel, ZRAM, sysctl, GameMode, Docker
│   │       ├── wireguard.nix       # WireGuard wg0 interface and DuckDNS timer
│   │       ├── duckdns.nix         # Standalone DuckDNS timer unit
│   │       ├── graph.nix           # Prometheus and Grafana stack definition
│   │       ├── steam.nix           # Steam firewall rules and configuration
│   │       ├── locale.nix          # Timezone and internationalization
│   │       └── modules.nix         # Host module imports
│   ├── nix-on-droid/
│   │   └── droid/
│   │       └── configuration.nix   # Android Termux Nix environment
│   └── user/
│       └── parrvx.nix              # Primary user profile declaration and SOPS hook
├── modules/
│   ├── flake/                      # Flake-parts output modules
│   │   ├── toplevel.nix            # Treefmt formatters & nixos-unified glue
│   │   ├── apps/                   # Custom symlink-wrapped CLI & GUI binaries
│   │   │   ├── helix.nix           # Customized Helix with bundled LSPs
│   │   │   ├── yazi.nix            # Customized Yazi file manager
│   │   │   ├── sioyek.nix          # Wrapped Sioyek PDF reader
│   │   │   └── iamb.nix            # Wrapped Iamb Matrix client
│   │   └── develop/                # Modular development shells
│   │       ├── devshell.nix        # Default shell & flake-automation scripts
│   │       ├── python.nix          # Python 3.13, Polars, DuckDB, Quarto, Evidence
│   │       └── rust.nix            # Rust toolchain (cargo, rustc, clippy, rustfmt)
│   ├── home/                       # Home Manager configuration modules
│   │   ├── shell.nix               # Bash, tmux, carapace, zoxide, fzf
│   │   ├── packages.nix            # User-level packages and wrapped apps
│   │   ├── pass.nix                # Passage & Age password setup
│   │   ├── even.nix                # Even Realities G2 Glasses systemd service
│   │   ├── firefox.nix             # Hardened Firefox profile + userChrome
│   │   ├── librewolf.nix           # Hardened LibreWolf profile
│   │   ├── gaming.nix              # Lutris, ProtonUp, Gamescope, VKD3D
│   │   ├── nh.nix                  # Nix Helper (`nh`) configuration
│   │   ├── nix-index.nix           # nix-index database & comma integration
│   │   ├── git.nix                 # Git and Lazygit configuration
│   │   ├── ssh.nix                 # Match blocks and key management
│   │   ├── virtualization.nix      # SPICE USB and user virtualization settings
│   │   └── river/                  # Wayland desktop configuration
│   │       ├── river.nix           # River WM session, rules, keymaps, and passage-menu
│   │       ├── fuzzel.nix          # App launcher styling
│   │       ├── foot.nix            # Terminal emulator configuration
│   │       ├── mako.nix            # Notification daemon styling
│   │       └── wlr.nix             # Modal which-key configuration
│   └── nixos/                      # System-level NixOS modules
│       ├── common/
│       │   ├── myusers.nix         # Declarative user generator
│       │   ├── tailscale.nix       # Tailscale daemon and firewall rules
│       │   └── virtualization.nix  # libvirtd, QEMU KVM, SPICE, and virt-manager
│       └── gui/
│           ├── river.nix           # System-level river-classic package and fonts
│           ├── keyboard.nix        # Kanata uinput service and keyboard layers
│           └── xdg.nix             # XDG Desktop Portals (wlr + GTK)
└── secrets/
    └── secrets.yaml                # Encrypted secrets managed via SOPS / Age
```

---

## Modular DevShells

Enter any isolated development environment with native Nix tooling:

* **Default / Flake Maintenance Shell** (`nix develop`):
  Provides custom automated shell commands:
  * `flake-update`: Update all flake input dependencies.
  * `flake-lint`: Auto-format all code using `treefmt` (`alejandra`, `prettier`, `shfmt`).
  * `flake-check`: Run complete evaluation and verification tests.
  * `flake-run`: Activate and build the local configuration.
  * `flake-help`: Display the interactive CLI help menu.
* **Python Data Science Shell** (`nix develop .#python`):
  Includes Python 3.13 bundled with **Polars**, **DuckDB**, **Quarto**, **Node.js**, `zk`, and dynamic library link configurations (`$LD_LIBRARY_PATH`) for building [Evidence](https://evidence.dev/) projects (`npx degit evidence-dev/template`).
* **Rust Toolchain Shell** (`nix develop .#rust`):
  Includes `cargo`, `rustc`, `rust-analyzer`, `clippy`, and `rustfmt`.

---

## Secrets Management (`sops-nix` & `passage`)

All sensitive credentials and certificates are encrypted at rest with Age in `secrets/secrets.yaml`:

* **Managed System Secrets**:
  * User login hashed password (`user_password`)
  * DuckDNS API token (`duckdns_token`)
  * WireGuard server private key (`wireguard_private_key`)
  * Grafana secret authentication key (`grafana_secret_key`)
  * Even Realities G2 terminal API token (`even_terminal_token`)
  * Anthropic and GitHub API tokens
* **Passage Integration**:
  Home Manager mounts your Age key file at `~/.config/sops/age/keys.txt` and manages passwords under `~/.passage`.
  * Trigger `Super + Shift + P` inside River to launch the custom fuzzy finder menu (`passage-menu`), copy decrypted credentials directly to `wl-clipboard`, and receive a desktop notification.

---

## Installation & Deployment

### 1. Fresh Machine Installation
Boot into the official NixOS Minimal Installer and clone or pull this repository:
```bash
# Run the automated disk partitioning and installation script
sudo ./assets/scripts/install.sh
```
Follow the interactive prompt to select your target drive (e.g. `nvme0n1` or `sda`), format the partitions (ESP FAT32 + Swap + Ext4 Root), generate system hardware configuration, and complete the base setup.

### 2. Flake Activation & Maintenance
On an existing running system, use either `just` or the native devshell commands:

```bash
# Enter the developer shell
nix develop

# Format all Nix, shell, and markdown files
flake-lint     # or: just lint / nix fmt

# Verify configuration validity
flake-check    # or: just check / nix flake check

# Switch and rebuild NixOS using nh
nh os switch ~/nix

# Update inputs across flake.lock
flake-update   # or: just update / nix flake update
```

### 3. Nix-on-Droid (Android / Termux)
Build and activate the `droid` target on your mobile device:
```bash
nix-on-droid switch --flake .#droid
```
