{
  perSystem = { pkgs, ... }: {
    devShells.python = pkgs.mkShell {
      name = "python-shell";
      meta.description = "Shell environment for Python Development";
      packages = with pkgs; [
        just
        nixd
        duckdb
        zk
      ];
      nativeBuildInputs = with pkgs; [
        quarto
        (python313.withPackages (ps: with ps; [
          polars
          duckdb
        ]))
        nodejs
        pkg-config
        stdenv.cc
      ];
      # Libraries that Python code needs to link against
      buildInputs = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        libxml2
      ];
      shellHook = ''
        # Vital for PyArrow and Polars to locate system libraries in Nix
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib pkgs.libxml2 ]}:$LD_LIBRARY_PATH"
        echo "To create your Evidence project, simply run in the terminal:"
        echo "npx degit evidence-dev/template my-project"
        echo "cd my-project"
        echo "npm install"
        echo "npm run dev"
      '';
    };
  };
}
