# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, pkgs, ... }:

{
  imports = [
    flake.inputs.self.nixosModules.common
  ];
}
