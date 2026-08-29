{pkgs, ...}: {
  home.packages = with pkgs; [
    gimp
    audacity
  ];
}
