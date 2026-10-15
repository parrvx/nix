{...}: {
  perSystem = {
    pkgs,
    lib,
    config,
    ...
  }: let
    keysUserConfig = pkgs.writeText "keys_user.config" ''
      next_page J
      previous_page K
    '';

    prefsUserConfig = pkgs.writeText "prefs_user.config" ''
      startup_commands toggle_dark_mode
    '';

    configDir = pkgs.runCommand "sioyek-config-dir" {} ''
      mkdir -p $out/sioyek
      cp ${keysUserConfig} $out/sioyek/keys_user.config
      cp ${prefsUserConfig} $out/sioyek/prefs_user.config
    '';
  in {
    packages.mysioyek = pkgs.symlinkJoin {
      name = "mysioyek";
      paths = [pkgs.sioyek];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/sioyek \
          --set XDG_CONFIG_HOME ${configDir}
      '';
      meta = {
        description = "Sioyek PDF viewer";
        mainProgram = "sioyek";
      };
    };
  };
}
