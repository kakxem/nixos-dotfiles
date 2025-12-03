#!/usr/bin/env bash

# Colors for pretty output
COLOR_RESET="\033[0m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_RED="\033[1;31m"

step()    { echo -e "${COLOR_BLUE}==>${COLOR_RESET} $1"; }
info()    { echo -e "${COLOR_YELLOW}  ->${COLOR_RESET} $1"; }
success() { echo -e "${COLOR_GREEN}✔${COLOR_RESET} $1"; }
error()   { echo -e "${COLOR_RED}✖ $1${COLOR_RESET}"; }

# Ensure script is run with sudo
if [[ $EUID -ne 0 ]]; then
  error "Please run this script with sudo."
  exit 1
fi
set -e

step "Starting NixOS dotfiles installation"

# Ensure we are in the repository root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"
info "Using repository root: $REPO_ROOT"

# Copy the hardware-configuration.nix from /etc/nixos
step "Copying /etc/nixos/hardware-configuration.nix to core/"
cp /etc/nixos/hardware-configuration.nix core/hardware-configuration.nix

# Ensure flakes and git are enabled in configuration.nix
CONFIG_FILE="/etc/nixos/configuration.nix"
step "Ensuring flakes and git are enabled in $CONFIG_FILE"

if ! grep -q 'experimental-features' "$CONFIG_FILE"; then
  # Add nix.settings.experimental-features at the top level so flakes can be used
  info "Adding nix.settings.experimental-features = [ \"nix-command\" \"flakes\" ]; to $CONFIG_FILE"
  # Insert before the final closing brace of the top-level attribute set
  sed -i '/^}/i\  nix.settings.experimental-features = [ "nix-command" "flakes" ];' "$CONFIG_FILE"
else
  info "experimental-features already configured in $CONFIG_FILE"
fi

if ! grep -q '\<git\>' "$CONFIG_FILE"; then
  # Add git to systemPackages
  info "Adding git to environment.systemPackages"
  sed -i '/systemPackages = with pkgs; \[/a\    git' "$CONFIG_FILE"
else
  info "git already present in environment.systemPackages"
fi

# Rebuild the system with flakes enabled using the current non-flake config
step "Rebuilding system to enable flakes and git (this may take a while)..."
NIXOS_CONFIG="${CONFIG_FILE}" nixos-rebuild switch

# Rebuild the system using the desktop flake from this repo
step "Rebuilding system using desktop flake (${REPO_ROOT}#desktop)..."
nixos-rebuild switch --flake "${REPO_ROOT}#desktop"

# Switch Home Manager configuration for the invoking user using the kakxem flake
if [[ -n "${SUDO_USER:-}" ]]; then
  step "Switching Home Manager configuration for ${SUDO_USER} (${REPO_ROOT}#kakxem)..."
  sudo -u "$SUDO_USER" home-manager switch --flake "${REPO_ROOT}#kakxem"
else
  info "SUDO_USER not set; skipping Home Manager switch. You can run 'rebuild-home' later as your normal user."
fi

success "NixOS dotfiles installation finished successfully."