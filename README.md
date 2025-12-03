# NixOS Configuration Flake

## Overview

This repository contains a NixOS configuration managed as a flake. It defines system settings, user environment, and a collection of modules for desktops and applications.

## Repository Structure

- `flake.nix` – Flake definition with inputs and outputs.
- `flake.lock` – Locked versions of inputs.
- `core/` – Core system configuration.
  - `configuration.nix` – Main NixOS configuration.
  - `hardware-configuration.nix` – Generated hardware config (do not edit manually).
  - `home.nix` – Home Manager configuration for the user.
- `modules/` – Reusable Nix modules.
  - `desktops/` – Desktop environment modules (GNOME, Hyprland, KDE).
  - `apps/` – Application modules (core apps, home apps).
- `scripts/` – Helper scripts (e.g., setup.sh).
- `wallpapers/` – Wallpaper assets.

## Installation (Flake)

Run the following commands (you can copy/paste this whole block):

```sh
# Enter a temporary shell that has git available
# (minimal NixOS does not include git by default)
nix-shell -p git

# Create the config directory if it does not exist
mkdir -p ~/.config

# Clone this repository into ~/.config/nixos-dotfiles
git clone https://github.com/kakxem/nixos-dotfiles.git ~/.config/nixos-dotfiles

# Leave the temporary nix-shell and go back to your normal shell
exit

# Enter the cloned configuration directory
cd ~/.config/nixos-dotfiles

# Add execution permissions to the install script
chmod +x ./scripts/install.sh

# Run the installation script to configure NixOS using this flake
sudo ./scripts/install.sh
```

## Customising

Edit `core/configuration.nix` to adjust system settings, enable/disable modules, or change packages. User‑specific settings are in `core/home.nix`.
