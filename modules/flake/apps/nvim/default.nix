{...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    nvimConfigDir = pkgs.stdenv.mkDerivation {
      name = "nvim-config";
      src = ./omerxx;
      installPhase = ''
        mkdir -p $out/nvim
        cp -r init.lua lua $out/nvim/
      '';
    };

    myNvim = pkgs.symlinkJoin {
      name = "mynvim";
      paths = [pkgs.neovim-unwrapped];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/nvim \
          --set XDG_CONFIG_HOME "${nvimConfigDir}" \
          --prefix PATH : ${lib.makeBinPath (with pkgs; [
          gcc
          ripgrep
          fd
          nil
          pyright
          gopls
          yamlfmt
        ])}
      '';
      meta = {mainProgram = "nvim";};
    };
  in {
    packages.mynvim = myNvim;
  };
}
