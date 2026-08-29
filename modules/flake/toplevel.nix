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

      # Ative os formatadores desejados
      programs = {
        alejandra.enable = true; # Formatação oficial/moderna de Nix
        prettier.enable = true; # Formatação de JSON, YAML, Markdown, etc.
        shfmt.enable = true; # Formatação de scripts Shell
      };
    };
    # Enables 'nix run' to activate.
    packages.default = self'.packages.activate;
  };
}
