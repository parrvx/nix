{ pkgs, flake, ... }:
{
   home.packages = with pkgs; with flake.inputs.self.packages.${pkgs.system}; [
    omnix
    ripgrep
    fd
    sd
    tree
    gnumake
    zk
    jujutsu
    aichat
    unzip
    anki
    cachix
    nil
    nix-info
    nixpkgs-fmt
    less
    nodejs
    ###### Standalone
    myzathura
    myyazi
    myiamb
    myhelix
    myqutebrowser
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;
    tmate.enable = true;
  }; 
}
