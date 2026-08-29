{...}: {
  perSystem = {
    pkgs,
    lib,
    config,
    ...
  }: let
    zathurarc = pkgs.writeText "zathurarc" ''
      set dbus-service true
      set exec-command "hx --remote-silent +%{line} %{input}"
      set selection-clipboard "clipboard"
    '';
    configDir = pkgs.runCommand "zathura-config-dir" {} ''
      mkdir -p $out/zathura
      cp ${zathurarc} $out/zathura/zathurarc
    '';
  in {
    packages.myzathura = pkgs.symlinkJoin {
      name = "myzathura";
      paths = [
        (pkgs.zathura.override {plugins = [pkgs.zathuraPkgs.zathura_pdf_mupdf];})
      ];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/zathura \
          --prefix PATH : ${lib.makeBinPath [config.packages.myhelix]} \
          --set XDG_CONFIG_HOME ${configDir}
      '';
      meta = {mainProgram = "zathura";};
    };
  };
}
