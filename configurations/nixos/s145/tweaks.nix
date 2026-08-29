{ flake, pkgs, ... }:

{
  # Linux Zen Kernel for enhanced gaming and high memory usage responsiveness
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.firewall.allowedTCPPorts = [ 3724 8085 22000 3456 ];

  services = {
    xserver.videoDrivers = [ "amdgpu" ];
    openssh.enable = true;
  };

  # =========================================================================
  # 1. EXTREME PERFORMANCE & MEMORY MANAGEMENT
  # =========================================================================
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8 * 1024; # 8 GB
  } ];

  boot.kernel.sysctl = {
    # Prevent system stalls when writing large data volumes to disk
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  # Enable GameMode to optimize CPU governor during execution
  programs.gamemode.enable = true;
  programs.nix-ld.enable = true;

  # AMD GPU acceleration (Mesa RADV + 32/64-bit Vulkan drivers)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  virtualisation.docker.enable = true;
}
