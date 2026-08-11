# Helix configuration managed using Nix
{ inputs, ... }:
{
  perSystem = { pkgs, lib, ... }:
    let
      # 1. Creates a physical directory in the Nix Store containing config.toml and languages.toml side-by-side
      helixConfigDir = pkgs.runCommand "helix-config-dir" {} ''
        mkdir -p $out
        cat << 'EOF' > $out/config.toml
theme = "ayu_evolve"
[editor]
line-number = "relative"
scrolloff = 7
mouse = false
idle-timeout = 50
auto-completion = true
completion-trigger-len = 1
[editor.soft-wrap]
enable = true
[editor.cursor-shape]
insert = "block"
normal = "block"
select = "underline"
[editor.lsp]
display-messages = true
display-inlay-hints = true
[editor.file-picker]
hidden = false
EOF
        cat << 'EOF' > $out/languages.toml
[language-server.zk]
command = "zk"
args = ["lsp"]
[[language]]
name = "markdown"
language-servers = ["zk", "marksman"]
EOF
      '';
      # 2. Wrapper pointing directly to config.toml inside the folder containing both files
      helixWithConfig = pkgs.symlinkJoin {
        name = "helix-configured";
        paths = [ pkgs.helix ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/hx \
            --add-flags "--config ${helixConfigDir}/config.toml" \
            --prefix PATH : ${lib.makeBinPath (with pkgs; [
              zk
              nil
              marksman
              pyright
              rust-analyzer
              bash-language-server
            ])}
        '';
      };
    in
    {
      packages.myhelix = helixWithConfig.overrideAttrs (oa: {
        meta = (oa.meta or {}) // {
          description = "Customized Helix editor";
          mainProgram = "hx";
        };
      });
    };
}
