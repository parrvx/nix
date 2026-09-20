{
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    NH_FLAKE = "${config.home.homeDirectory}/nix";
    FLAKE = "${config.home.homeDirectory}/nix";
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

  programs = {
    bash = {
      enable = true;
      shellAliases = {
        l = "ls -la";
        yz = "yazi";
        lg = "lazygit";
        v = "hx";
        ".." = "cd ..";
        "..." = "cd ../..";
        rb = "nh os switch ~/nix";
        nconf = "hx ~/nix";
        nfmt = "cd ~/nix && nix fmt && nix flake check && git add .";
        z = "zoxide";
      };
    };

    carapace = {
      enable = true;
      enableNushellIntegration = false;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      mouse = true;
      keyMode = "vi";
      baseIndex = 1;
      escapeTime = 0;
      extraConfig = ''
        set -g default-shell ${pkgs.bash}/bin/bash
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",xterm-256color:Tc"
        set -g status-position top
        set -g status-style "bg=#000000,fg=#13f507"
        set -g status-left " #[bold]#[fg=#13f507]  "
        set -g status-right "#[fg=#ffffff]%H:%M #[fg=#13f507] "
        set -g window-status-format " #I:#W "
        set -g window-status-style "fg=#555555"
        set -g window-status-current-format " #[bold]#I:#W* "
        set -g window-status-current-style "bg=#13f507,fg=#000000"
        set -g pane-border-style "fg=#1c1b22"
        set -g pane-active-border-style "fg=#13f507"
      '';
    };
  };
}
