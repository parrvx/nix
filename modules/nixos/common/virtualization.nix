<<<<<<< HEAD
# modules/nixos/virtualization.nix
# Configuração de virtualização para rodar MVs Windows/Linux com aceleração de hardware (KVM)
{ pkgs, config, ... }:

{
  # 1. Habilita o daemon do libvirtd para gerenciamento de MVs
=======
# Virtualization environment setup for running Windows/Linux VMs with hardware acceleration (KVM)
{ pkgs, config, ... }:
{
  # 1. Enable libvirtd daemon for virtual machine management
>>>>>>> 1705b6d (virtualization)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
<<<<<<< HEAD
      swtpm.enable = true; # Emulação de TPM 2.0 necessária para o Windows 11
    };
  };

  # 2. Habilita suporte a redirecionamento USB via SPICE (para repassar tokens USB para a MV)
  virtualisation.spiceUSBRedirection.enable = true;

  # 3. Adiciona seu usuário aos grupos necessários para rodar QEMU/KVM sem requerer sudo
=======
      swtpm.enable = true; # Software TPM 2.0 emulation required for Windows 11
    };
  };

  # 2. Enable SPICE USB redirection support (for passing USB tokens/devices to VMs)
  virtualisation.spiceUSBRedirection.enable = true;

  # 3. Add system user to required virtualization groups to run QEMU/KVM without sudo
>>>>>>> 1705b6d (virtualization)
  users.users.${config.me.username or "parrvx"}.extraGroups = [
    "kvm"
    "libvirtd"
    "qemu-libvirtd"
  ];

<<<<<<< HEAD
  # 4. Pacotes CLI e utilitários de virtualização no sistema
  environment.systemPackages = with pkgs; [
    quickemu      # CLI para baixar e subir MVs otimizadas com 1 comando
    virt-manager  # Inclui virt-install e virsh para gerenciamento avançado via terminal
    spice-gtk     # Cliente gráfico/remote-viewer para conexão SPICE e redirecionamento USB
    usbredir      # Ferramentas para repasse de dispositivos USB em tempo real
=======
  # 4. System CLI utilities and virtualization tools
  environment.systemPackages = with pkgs; [
    quickemu      # CLI tool to quickly download and launch optimized VMs
    virt-manager  # Includes virt-install and virsh for advanced VM management
    spice-gtk     # Graphical SPICE client for remote viewer and USB redirection
    usbredir      # Tools for real-time USB device pass-through
>>>>>>> 1705b6d (virtualization)
  ];
}
