{
  pkgs,
  flake,
  ...
}: {
  home.packages = with pkgs;
  with flake.inputs.self.packages.${pkgs.system}; [
    # Binários diretos
    duckdb
    typst

    # Python com as bibliotecas globais
    (python313.withPackages (ps:
      with ps; [
        polars
        duckdb
      ]))

    omnix
    ripgrep
    steam-run
    fd
    sd
    zk
    # jujutsu
    aichat
    ouch
    vim
    anki
    cachix
    nil
    nix-info
    nixpkgs-fmt
    nodejs
    termdown

    # Completions & Prompts

    # Rust Terminal Utilities
    dust
    delta
    bandwhich
    hyperfine
    onefetch
    gh
    yt-dlp

    ###### Custom Standalone Package Wrappers
    myzathura
    myyazi
    myiamb
    # myhelix
    mynvim
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    bottom.enable = true;
    tmate.enable = true;
  };
}
