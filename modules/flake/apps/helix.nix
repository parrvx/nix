# Helix configuration managed using Nix
{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    tomlFormat = pkgs.formats.toml {};

    # 1. TOML configurations generated natively by Nix
    configToml = tomlFormat.generate "config.toml" {
      theme = "ayu_evolve";
      editor = {
        line-number = "relative";
        scrolloff = 7;
        mouse = false;
        idle-timeout = 50;
        auto-completion = true;
        completion-trigger-len = 1;
        soft-wrap.enable = true;
        cursor-shape = {
          insert = "block";
          normal = "block";
          select = "underline";
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };
    };
    languagesToml = tomlFormat.generate "languages.toml" {
      language-server = {
        zk = {
          command = "zk";
          args = ["lsp"];
        };
        nil = {
          command = "nil";
        };
        pyright = {
          command = "pyright-langserver";
          args = ["--stdio"];
        };
      };
      language = [
        {
          name = "markdown";
          language-servers = ["zk"];
          roots = [".zk" ".git"];
        }
        {
          name = "nix";
          language-servers = ["nil"];
        }
        {
          name = "python";
          language-servers = ["pyright"];
        }
      ];
    };

    # 2. XDG_CONFIG_HOME structure generated in the Nix Store
    helixConfigDir = pkgs.runCommand "helix-config-dir" {} ''
      mkdir -p $out/helix
      cp ${configToml} $out/helix/config.toml
      cp ${languagesToml} $out/helix/languages.toml
    '';

    # 3. Wrapper extending PATH with LSPs
    helixWithConfig = pkgs.symlinkJoin {
      name = "helix-configured";
      paths = [pkgs.helix];
      nativeBuildInputs = [pkgs.makeWrapper];
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
  in {
    packages.myhelix = helixWithConfig.overrideAttrs (oa: {
      meta =
        (oa.meta or {})
        // {
          description = "Customized Helix editor";
          mainProgram = "hx";
        };
    });
  };
}
