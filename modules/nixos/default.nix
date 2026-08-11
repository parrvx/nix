# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, pkgs, ... }:

{
  imports = [
    flake.inputs.self.nixosModules.common
  ];

  networking.firewall.allowedTCPPorts = [ 3724 8085 ];

  services = {
    xserver.videoDrivers = [ "amdgpu" ];
    openssh.enable = true;
    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };
  };

  # =========================================================================
  # 1. EXTREME PERFORMANCE & MEMORY MANAGEMENT
  # =========================================================================
  
  # Enable and configure zRam as a compressed swap device
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100; 
  };

  # Define a fallback secondary swap file on the SSD
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8 * 1024; # 8 GB
  } ];

  # Tweak the Linux kernel to aggressively use zRam before touching the SSD
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.watermark_boost_factor" = 0;
  };

  # =========================================================================
  # 3. GRAPHICS & GAMING SUPPORT (Wine / Lutris)
  # =========================================================================
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  virtualisation.docker.enable = true;

}
