{ pkgs, flake, ... }:

{
  home.packages = with pkgs; with flake.inputs.self.packages.${pkgs.system}; [
    omnix
    ripgrep
    fd
    sd
    zk
    jujutsu
    aichat
    ouch
    anki
    cachix
    nil
    nix-info
    nixpkgs-fmt
    nodejs

    # Completions & Prompts
    carapace

    # Rust Terminal Utilities
    eza
    dust
    procs
    delta
    bandwhich
    hyperfine
    grex
    onefetch
    gh
    yt-dlp

    ###### Custom Standalone Package Wrappers
    myzathura
    myyazi
    myiamb
    myhelix
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    bottom.enable = true;
    tmate.enable = true;
  };
}
