{
  perSystem = { pkgs, ... }: {
    devShells.wow_server = pkgs.mkShell {
      name = "wow_server-shell";
      meta.description = "Development and compilation shell for AzerothCore WotLK server";

      # Native build inputs needed for compiling AzerothCore
      packages = with pkgs; [
        git
        cmake
        gnumake
        clang
        openssl
        bzip2
        readline
        zlib
        boost
        mysql80
        pkg-config
      ];

      shellHook = ''
        echo "========================================================="
        echo "      AzerothCore Native Environment Is Now Active"
        echo "========================================================="
        echo "  All compilation dependencies and libraries are ready."
        echo "  Run your cmake and make commands directly inside here."
        echo "========================================================="
      '';
    };
  };
}
