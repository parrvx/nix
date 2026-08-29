{...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    tomlFormat = pkgs.formats.toml {};

    iambConfig = tomlFormat.generate "config.toml" {
      default_profile = "user";
      profiles."user" = {
        url = "https://matrix.org";
        user_id = "@parrvx:matrix.org";
      };
    };

    configDir = pkgs.runCommand "iamb-config-dir" {} ''
      mkdir -p $out/iamb
      cp ${iambConfig} $out/iamb/config.toml
    '';
  in {
    packages.myiamb = pkgs.symlinkJoin {
      name = "myiamb";

      paths = [pkgs.iamb];
      buildInputs = [pkgs.makeWrapper];

      postBuild = ''
        wrapProgram $out/bin/iamb \
          --set XDG_CONFIG_HOME ${configDir}
      '';

      meta = {mainProgram = "iamb";};
    };
  };
}
