# Top-level flake glue to get our configuration working
{inputs, ...}: {
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
    inputs.treefmt-nix.flakeModule
    ./apps/default.nix
  ];
  perSystem = {
    self',
    pkgs,
    ...
  }: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        alejandra.enable = true;
        prettier.enable = true;
        shfmt.enable = true;
      };
    };
    packages.default = self'.packages.activate;
  };
}
