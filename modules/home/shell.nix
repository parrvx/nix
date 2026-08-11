{ config, pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs = {
    nushell = {
      enable = true;
      configFile.text = ''
        $env.config = {
          show_banner: false
        }
      '';
      environmentVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
        NH_FLAKE = "${config.home.homeDirectory}/nix";
        FLAKE = "${config.home.homeDirectory}/nix";
      };
    };

    zellij = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;

      settings = {
        theme = "matrix";
        themes = {
          matrix = {
            fg = "#13f507";
            bg = "#000000";
            black = "#000000";
            red = "#ff0055";
            green = "#39ff14";
            yellow = "#faff00";
            blue = "#13f507";
            magenta = "#ff0055";
            cyan = "#49e9a6";
            white = "#ffffff";
            orange = "#ff9e3b";
          };
        };
      
        scrollback_editor = "hx";
        ui = {
          pane_frames = {
            hide_session_name = true;
          };
        };
        default_layout = "compact";
        pane_frames = false;
        show_startup_tips = false;
      };
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
