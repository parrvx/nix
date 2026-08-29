# Helix configuration managed using Nix
{ inputs, ... }: {
  perSystem = { pkgs, lib, ... }:
    let
      # 1. Cria a estrutura simulando ~/.config/helix
      helixConfigDir = pkgs.runCommand "helix-config-dir" { } ''
                mkdir -p $out/helix
        
                # --- CONFIG.TOML ---
                cat << 'EOF' > $out/helix/config.toml
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

                # --- LANGUAGES.TOML ---
                cat << 'EOF' > $out/helix/languages.toml
        [language-server.zk]
        command = "zk"
        args = ["lsp"]

        [[language]]
        name = "markdown"
        language-servers = [ "zk" ]
        roots = [".zk", ".git"]
        EOF
      '';

      # 2. Wrapper utilizando XDG_CONFIG_HOME (mesma técnica do seu Zathura)
      helixWithConfig = pkgs.symlinkJoin {
        name = "helix-configured";
        paths = [ pkgs.helix ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/hx \
            --set XDG_CONFIG_HOME "${helixConfigDir}" \
            --prefix PATH : ${lib.makeBinPath (with pkgs; [
              zk
              nil
              pyright
              rust-analyzer
              bash-language-server
            ])}
        '';
      };
    in
    {
      packages.myhelix = helixWithConfig.overrideAttrs (oa: {
        meta = (oa.meta or { }) // {
          description = "Customized Helix editor";
          mainProgram = "hx";
        };
      });
    };
}
