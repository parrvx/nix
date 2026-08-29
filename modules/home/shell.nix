{ config, pkgs, ... }:
{
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
      enableCompletion = true;
      initExtra = ''
<<<<<<< HEAD
        # Prompt enxuto e rápido
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        
        # Integração do Carapace para autocompletar avançado no Bash
=======
        # Minimal and fast prompt
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        
        # Carapace integration for advanced command autocompletion in Bash
>>>>>>> 1705b6d (virtualization)
        source <(carapace _carapace bash)
      '';
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

<<<<<<< HEAD
    # Tmux (~2MB RAM)
=======
    # Tmux configuration (~2MB RAM footprint)
>>>>>>> 1705b6d (virtualization)
    tmux = {
      enable = true;
      clock24 = true;
      mouse = true;
      keyMode = "vi";
      baseIndex = 1;
      escapeTime = 0;
      extraConfig = ''
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
