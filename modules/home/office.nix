{pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice
    gimp
    audacity
  ];
}
