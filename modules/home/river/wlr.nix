{ pkgs
, lib
, config
, ...
}:
let
  mkMenu =
    menu:
    let
      configFile = pkgs.writeText "config.yaml" (
        lib.generators.toYAML { } {
          anchor = "center";
          background = "#000000";
          color = "#13f507";
          border = "#13f507";
          separator = " - ";
          border_width = 2;
          corner_r = 15;
          padding = 15;
          rows_per_column = 5;
          inherit menu;
        }
      );
    in
    pkgs.writeShellScriptBin "my-menu" ''
      exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
    '';
in
{
  wayland.windowManager.river.settings.map.normal = [
    (
      "Super D spawn "
      + lib.getExe (mkMenu [
        {
          key = "g";
          desc = "Gaming (Lutris)";
          cmd = "lutris";
        }
        {
          key = "o";
          desc = "Libreoffice";
          cmd = "libreoffice";
        }
        {
          key = "f";
          desc = "Find (Yazi)";
          cmd = "footclient -e yazi";
        }
        {
          key = "n";
          desc = "Note (Helix)";
          cmd = "footclient bash -c 'cd ${config.home.homeDirectory}/zk; hx .'";
        }
        {
          key = "t";
          desc = "Terminal (tmux)";
          cmd = "footclient tmux new-session -A -s main";
        }
        {
          key = "m";
          desc = "Matrix (Iamb)";
          cmd = "footclient -e iamb";
        }
      ])
    )
    (
      "Super S spawn "
      + lib.getExe (mkMenu [
        {
          key = "d";
          desc = "Shutdown";
          cmd = "systemctl poweroff";
        }
        {
          key = "r";
          desc = "Reboot";
          cmd = "systemctl reboot";
        }
        {
          key = "t";
          desc = "Bottom";
          cmd = "footclient -e btm";
        }
        {
          key = "v";
          desc = "Volume";
          cmd = "footclient pulsemixer";
        }
      ])
    )
    (
      "Super M spawn "
      + lib.getExe (mkMenu [
        {
          key = "t";
          desc = "Terminal Mode";
          cmd = "bash ${config.home.homeDirectory}/nix/assets/scripts/terminal.sh";
        }
        {
          key = "d";
          desc = "Develop Mode";
          cmd = "footclient bash -c 'cd ${config.home.homeDirectory}/nix && nix develop && cd ${config.home.homeDirectory}/zk/project'";
        }
        {
          key = "e";
          desc = "Even G2 Terminal";
          cmd = "footclient -e npx --yes @evenrealities/even-terminal --provider claude";
        }
        {
          key = "l";
          desc = "Legal Mode";
          cmd = "steam-run bash ${config.home.homeDirectory}/Documents/pje/pjeoffice-pro.sh";
        }
        {
          key = "v";
          desc = "Volume";
          cmd = "footclient pulsemixer";
        }
      ])
    )
    (
      "Super G spawn "
      + lib.getExe (mkMenu [
        {
          key = "f";
          desc = "Factorio";
          cmd = "lutris lutris:rungameid/4";
        }
        {
          key = "c";
          desc = "Google Chrome";
          cmd = "chromium";
        }
      ])
    )
    (
      "Super N spawn "
      + lib.getExe (mkMenu [
        {
          key = "t";
          desc = "Test";
          cmd = "foot -e nix flake check ${config.home.homeDirectory}/nix";
        }
        {
          key = "r";
          desc = "Rebuild";
          cmd = "foot -e nh os switch ${config.home.homeDirectory}/nix";
        }
        {
          key = "c";
          desc = "Collect (Garbage)";
          cmd = "foot -e nh clean all";
        }
      ])
    )
  ];
}
