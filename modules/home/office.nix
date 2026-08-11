{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gimp
    libreoffice
    audacity
  ];
}
