{
  flake,
  pkgs,
  ...
}: {
  # Imports reusable Nix-on-Droid modules
  imports = [
    ./configuration.nix
  ];
}
