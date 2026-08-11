{
  perSystem = { pkgs, ... }: {
    devShells.rust = pkgs.mkShell {
      name = "rust-shell";
             
      packages = with pkgs; [
        cargo
        rustc
        rust-analyzer
        clippy
        rustfmt
      ];
      shellHook = ''
        echo "========================================================="
        echo "   Active Rust Development Environment via Nix"
        echo "========================================================="
      '';
    };
  };
}
