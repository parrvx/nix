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
    ollama-rocm

    # Python com as bibliotecas globais
    (python313.withPackages (ps:
      with ps; [
        polars
        duckdb
      ]))

    # Office
    gimp

    omnix
    ripgrep
    steam-run
    fd
    sd
    aichat
    ouch
    anki
    cachix
    nil
    nix-info
    nixpkgs-fmt
    nodejs
    termdown
    visidata
    markdown-oxide

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
    # myzathura
    myyazi
    myiamb
    myhelix
    mynvim
    mysioyek
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    bottom.enable = true;
    tmate.enable = true;
  };
}
