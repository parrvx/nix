{ pkgs, flake, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; with flake.inputs.self.packages.${pkgs.system}; [

    lutris
    protonup-qt
    winetricks
    vkd3d
  ];

}
