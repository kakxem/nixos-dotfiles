{ pkgs, user, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "rebuild-system" ''
      set -euo pipefail

      # Always rebuild from your live checkout
      FLAKE_PATH="$HOME/.config/nixos-dotfiles"
      FLAKE_OUTPUT="system"

      # If not running as root, re-exec via sudo.
      # We don't interpolate FLAKE_PATH via Nix, so it won't be frozen in the store.
      if [ "$EUID" -ne 0 ]; then
        exec sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "$FLAKE_PATH#$FLAKE_OUTPUT"
      else
        exec ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "$FLAKE_PATH#$FLAKE_OUTPUT"
      fi
    '')

    (pkgs.writeShellScriptBin "rebuild-home" ''
      set -euo pipefail

      if [ "$EUID" -eq 0 ]; then
        echo "rebuild-home: this script should be run as your regular user, not as root." >&2
        exit 1
      fi

      FLAKE_PATH="$HOME/.config/nixos-dotfiles"
      FLAKE_OUTPUT="${user}"
      
      exec ${pkgs.home-manager}/bin/home-manager switch --flake "$FLAKE_PATH#$FLAKE_OUTPUT"
    '')
  ];
}
