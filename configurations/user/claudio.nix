{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.default
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/claudio/.config/sops/age/keys.txt";
  };

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = {
    username = "claudio";
    fullname = "claudio";
    email = "claudio@gmail.com";
  };

  home.stateVersion = "24.11";
}
