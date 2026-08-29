{ config, pkgs, ... }:
{
  networking.hostName = "s145";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS printing service
  services.printing.enable = true;

  # Audio setup with PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # =========================================================================
  # SOPS-NIX SECRETS MANAGEMENT
  # =========================================================================
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml; # Encrypted YAML target
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/parrvx/.config/sops/age/keys.txt"; # Host private key path
  };

  # Password secret declaration
  sops.secrets.user_password = {
    neededForUsers = true;
  };

  # User consuming hashed password managed via sops-nix
  users.users.parrvx = {
    isNormalUser = true;
    description = "parrvx";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    hashedPasswordFile = config.sops.secrets.user_password.path;
  };

  # Passwordless sudo for rebuild automation scripts
  security.sudo.extraRules = [
    {
      users = [ "parrvx" ];
      commands = [
        { command = "/run/current-system/sw/bin/nixos-rebuild"; options = [ "NOPASSWD" ]; }
        { command = "/nix/store/*/bin/nix-env"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/nix-env"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  nix.package = pkgs.lix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
