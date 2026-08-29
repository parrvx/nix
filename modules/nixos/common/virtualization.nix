# modules/nixos/common/virtualization.nix
# Virtualization environment setup for running Windows/Linux VMs with hardware acceleration (KVM)
{ pkgs, config, ... }:
{
  # 1. Enable libvirtd daemon for virtual machine management
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true; # Software TPM 2.0 emulation required for Windows 11
    };
  };

  # 2. Enable SPICE USB redirection support (for passing USB tokens/devices to VMs)
  virtualisation.spiceUSBRedirection.enable = true;

  # 3. Add system user to required virtualization groups to run QEMU/KVM without sudo
  users.users.${config.me.username or "parrvx"}.extraGroups = [
    "kvm"
    "libvirtd"
    "qemu-libvirtd"
  ];

  # 4. System CLI utilities and virtualization tools
  environment.systemPackages = with pkgs; [
    quickemu # CLI tool to quickly download and launch optimized VMs
    virt-manager # Includes virt-install and virsh for advanced VM management
    spice-gtk # Graphical SPICE client for remote viewer and USB redirection
    usbredir # Tools for real-time USB device pass-through
  ];
}
