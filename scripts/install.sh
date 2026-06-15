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

FLAKE_USER="$(sed -n 's/^[[:space:]]*user[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' vars.nix)"
if [[ -z "$FLAKE_USER" ]]; then
  error "Could not read user from vars.nix."
  exit 1
fi

step "Current vars.nix configuration"
sed -n '1,80p' vars.nix
info "Review these values before installing, especially user, Git identity, system, and desktop."

if [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != "$FLAKE_USER" ]]; then
  error "SUDO_USER is '$SUDO_USER', but vars.nix user is '$FLAKE_USER'."
  info "Edit vars.nix or run the installer from the intended user account."
  exit 1
fi

read -r -p "Do you want to continue with this configuration? [y/N]: " CONFIRM
CONFIRM="${CONFIRM,,}"
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "yes" ]]; then
  info "Installation cancelled. Edit vars.nix and run the installer again when ready."
  exit 0
fi

# Copy the hardware-configuration.nix from /etc/nixos
if [[ ! -f /etc/nixos/hardware-configuration.nix ]]; then
  error "Could not find /etc/nixos/hardware-configuration.nix."
  info "Generate it with: sudo nixos-generate-config --show-hardware-config"
  exit 1
fi

step "Copying /etc/nixos/hardware-configuration.nix to modules/config/hardware/"
cp /etc/nixos/hardware-configuration.nix modules/config/hardware/generated.nix

# Build the system generation for next boot without disrupting the live desktop session.
step "Building system generation for next boot (${REPO_ROOT}#system)..."
nixos-rebuild boot --extra-experimental-features "nix-command flakes" --flake "${REPO_ROOT}#system"

if [[ -n "${SUDO_USER:-}" ]]; then
  step "Switching Home Manager configuration for ${SUDO_USER} (${REPO_ROOT}#${FLAKE_USER})..."
  sudo -i -u "$SUDO_USER" nix --extra-experimental-features "nix-command flakes" run github:nix-community/home-manager -- switch -b backup --flake "${REPO_ROOT}#${FLAKE_USER}"
else
  info "SUDO_USER not set; skipping Home Manager switch. You can run 'rebuild-home' after reboot as your regular user."
fi

success "NixOS system generation installed for next boot and Home Manager activation finished."
info "Reboot into the new generation to complete the installation."
