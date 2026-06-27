{ pkgs, user, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "rebuild-system" ''
      set -euo pipefail

      # Always rebuild from your live checkout
      FLAKE_PATH="''${FLAKE_PATH:-$HOME/.config/nixos-dotfiles}"
      FLAKE_OUTPUT="system"
      KEEP_GENERATIONS=5
      CLEAN_MODE="ask"
      ORIGINAL_ARGS=("$@")

      section() {
        echo
        echo "== $1 =="
      }

      info() {
        echo "-> $1"
      }

      success() {
        echo "OK: $1"
      }

      run_garbage_collection() {
        local columns="''${COLUMNS:-80}"
        local max_width=$((columns > 4 ? columns - 4 : 76))
        local status=0
        ${pkgs.nix}/bin/nix-collect-garbage 2>&1 \
          | while IFS= read -r line; do
              local display="$line"
              if [ "''${#display}" -gt "$max_width" ]; then
                display="''${display:0:$max_width}..."
              fi
              printf '\r\033[2K%s' "$display"
            done || status=$?
        printf '\n'
        return "$status"
      }

      usage() {
        echo "Usage: rebuild-system [--yes|--no-clean]"
        echo "  --yes       Prune old generations and run GC without asking"
        echo "  --no-clean  Skip generation pruning and GC"
        echo
        echo "Default: ask after a successful rebuild."
      }

      while [ "$#" -gt 0 ]; do
        case "$1" in
          --yes|-y)
            CLEAN_MODE="yes"
            ;;
          --no-clean)
            CLEAN_MODE="no"
            ;;
          --help|-h)
            usage
            exit 0
            ;;
          *)
            echo "rebuild-system: unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
        esac
        shift
      done

      should_clean() {
        case "$CLEAN_MODE" in
          yes)
            return 0
            ;;
          no)
            return 1
            ;;
        esac

        local answer
        echo "Cleanup keeps the newest $KEEP_GENERATIONS system generations and always protects /run/current-system."
        read -r -p "Run cleanup now? [y/N] " answer || return 1
        [[ "$answer" =~ ^[Yy]$|^[Yy][Ee][Ss]$ ]]
      }

      prune_system_generations() {
        local current_system
        current_system="$(${pkgs.coreutils}/bin/readlink -f /run/current-system)"

        local ids=()
        local line id
        while IFS= read -r line; do
          if [[ "$line" =~ ^[[:space:]]*([0-9]+)[[:space:]] ]]; then
            ids+=("''${BASH_REMATCH[1]}")
          fi
        done < <(${pkgs.nix}/bin/nix-env --list-generations --profile /nix/var/nix/profiles/system)

        local count="''${#ids[@]}"
        if [ "$count" -le "$KEEP_GENERATIONS" ]; then
          info "System generations: $count found, limit is $KEEP_GENERATIONS; nothing to prune."
          return 0
        fi

        local first_kept=$((count - KEEP_GENERATIONS))
        local delete_generations=()
        local i generation_path
        for ((i = 0; i < first_kept; i++)); do
          id="''${ids[$i]}"
          generation_path="$(${pkgs.coreutils}/bin/readlink -f "/nix/var/nix/profiles/system-$id-link")"
          if [ "$generation_path" != "$current_system" ]; then
            delete_generations+=("$id")
          fi
        done

        if [ "''${#delete_generations[@]}" -gt 0 ]; then
          info "Removing old system generations: ''${delete_generations[*]}"
          ${pkgs.nix}/bin/nix-env --delete-generations --profile /nix/var/nix/profiles/system "''${delete_generations[@]}"
        else
          info "No system generations can be removed without touching the current system."
        fi
      }

      # If not running as root, re-exec via sudo.
      # We don't interpolate FLAKE_PATH via Nix, so it won't be frozen in the store.
      if [ "$EUID" -ne 0 ]; then
        exec sudo ${pkgs.coreutils}/bin/env FLAKE_PATH="$FLAKE_PATH" "$0" "''${ORIGINAL_ARGS[@]}"
      fi

      section "NixOS Rebuild"
      info "Flake: $FLAKE_PATH#$FLAKE_OUTPUT"
      info "Cleanup mode: $CLEAN_MODE"
      info "Starting system switch..."
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "$FLAKE_PATH#$FLAKE_OUTPUT"
      success "System rebuild finished."

      section "Cleanup"
      if should_clean; then
        info "Pruning system generations..."
        prune_system_generations
        info "Running Nix garbage collection..."
        run_garbage_collection
        success "System cleanup finished."
      else
        info "Skipping system cleanup."
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
      KEEP_GENERATIONS=5
      CLEAN_MODE="ask"

      section() {
        echo
        echo "== $1 =="
      }

      info() {
        echo "-> $1"
      }

      success() {
        echo "OK: $1"
      }

      run_garbage_collection() {
        local columns="''${COLUMNS:-80}"
        local max_width=$((columns > 4 ? columns - 4 : 76))
        local status=0
        ${pkgs.nix}/bin/nix-collect-garbage 2>&1 \
          | while IFS= read -r line; do
              local display="$line"
              if [ "''${#display}" -gt "$max_width" ]; then
                display="''${display:0:$max_width}..."
              fi
              printf '\r\033[2K%s' "$display"
            done || status=$?
        printf '\n'
        return "$status"
      }

      usage() {
        echo "Usage: rebuild-home [--yes|--no-clean]"
        echo "  --yes       Prune old generations and run GC without asking"
        echo "  --no-clean  Skip generation pruning and GC"
        echo
        echo "Default: ask after a successful rebuild."
      }

      while [ "$#" -gt 0 ]; do
        case "$1" in
          --yes|-y)
            CLEAN_MODE="yes"
            ;;
          --no-clean)
            CLEAN_MODE="no"
            ;;
          --help|-h)
            usage
            exit 0
            ;;
          *)
            echo "rebuild-home: unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
        esac
        shift
      done

      should_clean() {
        case "$CLEAN_MODE" in
          yes)
            return 0
            ;;
          no)
            return 1
            ;;
        esac

        local answer
        echo "Cleanup keeps the newest $KEEP_GENERATIONS Home Manager generations and always protects the current generation."
        read -r -p "Run cleanup now? [y/N] " answer || return 1
        [[ "$answer" =~ ^[Yy]$|^[Yy][Ee][Ss]$ ]]
      }

      prune_home_generations() {
        local ids=()
        local current_id=""
        local line id
        while IFS= read -r line; do
          if [[ "$line" =~ id[[:space:]]+([0-9]+) ]]; then
            id="''${BASH_REMATCH[1]}"
            ids+=("$id")
            if [[ "$line" == *"(current)"* ]]; then
              current_id="$id"
            fi
          fi
        done < <(${pkgs.home-manager}/bin/home-manager generations)

        local count="''${#ids[@]}"
        if [ "$count" -le "$KEEP_GENERATIONS" ]; then
          info "Home Manager generations: $count found, limit is $KEEP_GENERATIONS; nothing to prune."
          return 0
        fi

        local delete_generations=()
        local i
        for ((i = KEEP_GENERATIONS; i < count; i++)); do
          id="''${ids[$i]}"
          if [ "$id" != "$current_id" ]; then
            delete_generations+=("$id")
          fi
        done

        if [ "''${#delete_generations[@]}" -gt 0 ]; then
          info "Removing old Home Manager generations: ''${delete_generations[*]}"
          ${pkgs.home-manager}/bin/home-manager remove-generations "''${delete_generations[@]}"
        else
          info "No Home Manager generations can be removed without touching the current generation."
        fi
      }

      section "Home Manager Rebuild"
      info "Flake: $FLAKE_PATH#$FLAKE_OUTPUT"
      info "Cleanup mode: $CLEAN_MODE"
      info "Starting Home Manager switch..."
      ${pkgs.home-manager}/bin/home-manager switch -b backup --flake "$FLAKE_PATH#$FLAKE_OUTPUT"
      success "Home Manager rebuild finished."

      section "Cleanup"
      if should_clean; then
        info "Pruning Home Manager generations..."
        prune_home_generations
        info "Running Nix garbage collection..."
        run_garbage_collection
        success "Home Manager cleanup finished."
      else
        info "Skipping Home Manager cleanup."
      fi
    '')
  ];
}
