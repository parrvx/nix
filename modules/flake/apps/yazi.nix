{ ... }:
{
  perSystem = { pkgs, lib, config, ... }:
    let
      tomlFormat = pkgs.formats.toml { };
      yaziToml = tomlFormat.generate "yazi.toml" {
        mgr = { ratio = [ 1 1 6 ]; };
        opener = {
          edit = [{ run = "hx \"$@\""; block = true; desc = "Helix"; }];
          play = [{ run = "mpv \"$@\""; orphan = true; for = "unix"; }];
          display = [{ run = "imv \"$@\""; orphan = true; for = "unix"; }];
          pdf = [{ run = "zathura \"$@\""; orphan = true; for = "unix"; }];
        };
        open = {
          rules = [
            { name = "*.md"; use = "edit"; }
            { name = "*.txt"; use = "edit"; }
            { mime = "text/*"; use = "edit"; }
            { mime = "video/*"; use = "play"; }
            { mime = "image/*"; use = "display"; }
            { mime = "application/pdf"; use = "pdf"; }
          ];
        };
      };
      keymapToml = tomlFormat.generate "keymap.toml" {
        mgr = {
          prepend_keymap = [
            { on = [ "g" "t" ]; run = "shell lazygit --block --confirm"; desc = "Open lazygit"; }
            { on = [ "g" "z" ]; run = "cd ~/zk"; desc = "Go to Vault"; }
            { on = [ "n" "e" ]; run = "shell 'cd ~/zk && hx' --block --confirm"; desc = "Open Helix"; }
            { on = [ "n" "n" ]; run = "shell 'cd ~/zk && hx \"$(zk new --dir -p)\"' --block --confirm"; desc = "New Note (zk)"; }
            { on = [ "n" "d" ]; run = "shell 'cd ~/zk && hx \"$(zk new --group journal -p)\"' --block --confirm"; desc = "New Daily Note (zk)"; }
            { on = [ "n" "f" ]; run = "shell 'cd ~/zk && ZK_EDITOR=hx zk edit -i' --block --confirm"; desc = "Search Note (fzf)"; }
          ];
        };
      };
      configDir = pkgs.runCommand "yazi-config-dir" { } ''
        mkdir -p $out
        cp ${yaziToml} $out/yazi.toml
        cp ${keymapToml} $out/keymap.toml
      '';
    in
    {
      packages.myyazi = pkgs.symlinkJoin {
        name = "myyazi";
        paths = [ pkgs.yazi ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/yazi \
            --prefix PATH : ${lib.makeBinPath (with pkgs; [
                ffmpeg p7zip poppler fd ripgrep fzf
               lazygit zk mpv imv zathura
               config.packages.myhelix
             ])} \
            --set YAZI_CONFIG_HOME ${configDir}
        '';
        meta = { mainProgram = "yazi"; };
      };
    };
}
