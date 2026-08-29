{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gimp
    obsidian
    libreoffice-fresh
    audacity
  ];
}
