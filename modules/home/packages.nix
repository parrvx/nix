{
  pkgs,
  flake,
  ...
}: {
  home.packages = with pkgs;
  with flake.inputs.self.packages.${pkgs.system}; [
    # Direct standalone binaries
    duckdb
    typst
    ollama-rocm

    # Python environment with global packages
    (python313.withPackages (ps:
      with ps; [
        polars
        duckdb
      ]))

    # Office & productivity
    gimp
    omnix
    ripgrep
    steam-run
    fd
    jq
    fzf
    bottom
    tmate
    bat
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
    myyazi
    myiamb
    myhelix
    mysioyek
  ];
}
