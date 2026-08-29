{
  perSystem = {pkgs, ...}: let
    # --- Native Shell Automation Scripts ---
    # These replace the external 'justfile' tasks with native Nix shell scripts
    # Replaces 'just update'
    flakeUpdate = pkgs.writeShellScriptBin "flake-update" ''
      # Update all flake inputs to their latest versions
      echo "🔄 Updating Nix flake inputs..."
      nix flake update
    '';

    # Replaces 'just lint'
    flakeLint = pkgs.writeShellScriptBin "flake-lint" ''
      # Format all Nix files using the configured formatter
      echo "🎨 Formatting Nix files..."
      nix fmt
    '';

    # Replaces 'just check'
    flakeCheck = pkgs.writeShellScriptBin "flake-check" ''
      # Run evaluation and validation checks on the flake configuration
      echo "🔍 Checking flake configuration..."
      nix flake check
    '';

    # Replaces 'just run'
    flakeRun = pkgs.writeShellScriptBin "flake-run" ''
      # Build and activate the current configuration locally
      echo "🚀 Activating system configuration..."
      nix run
    '';

    # Replaces 'just' or 'just --list' default view
    shellHelp = pkgs.writeShellScriptBin "flake-help" ''
      echo "========================================================="
      echo "⚡ Matrix NixOS Configuration - DevShell Automation Tasks"
      echo "========================================================="
      echo "Available commands:"
      echo "  flake-update  - Update all flake inputs"
      echo "  flake-lint    - Format all Nix files using nixpkgs-fmt"
      echo "  flake-check   - Run checks to ensure configuration validity"
      echo "  flake-run     - Build and switch to/activate the configuration"
      echo "  flake-help    - Show this help menu"
      echo "========================================================="
    '';
  in {
    devShells.default = pkgs.mkShell {
      name = "nixos-unified-template-shell";
      meta.description = "Shell environment for modifying this Nix configuration";

      # Include both standard development utilities and our custom automation tools
      packages = with pkgs; [
        nixd # Nix language server for IDE integration

        # Custom local commands
        flakeUpdate
        flakeLint
        flakeCheck
        flakeRun
        shellHelp
      ];

      # Code executed automatically upon entering the devShell or via direnv activation
      shellHook = ''
        # Display the help menu immediately to guide the user on available tasks
        flake-help
      '';
    };
  };
}
