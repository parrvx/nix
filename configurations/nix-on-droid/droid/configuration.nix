{ config, lib, pkgs, ... }:
{
  environment.packages = with pkgs; [
    vim
    helix
    yazi
    lazygit
    openssh
    git
    zk
  ];

  environment.etcBackupExtension = ".bak";
  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  android-integration.termux-setup-storage.enable = true;
  user.shell = "${pkgs.nushell}/bin/nu";
}
