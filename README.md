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

## Switching Desktop Environments

This configuration supports multiple desktop environments (GNOME, Hyprland, KDE, Cosmic) via a unified parameter `desktop`. By default, GNOME is selected.

### Using the pre‑installed scripts

The system provides two convenience commands:

- `rebuild-desktop` – rebuilds the system configuration (requires sudo)
- `rebuild-home` – rebuilds the user’s home‑manager configuration

Both scripts now accept an optional environment variable `DESKTOP` to choose the desktop. For example:

```bash
DESKTOP=hyprland rebuild-desktop
DESKTOP=hyprland rebuild-home
```

If `DESKTOP` is not set, the default (`gnome`) is used.

### Manual rebuild with explicit desktop

You can also run the underlying flake commands directly:

```bash
# Rebuild system with Hyprland
sudo nixos-rebuild switch --flake ~/.config/nixos-dotfiles#desktop --argstr desktop "hyprland"

# Rebuild home‑manager with Hyprland
home-manager switch --flake ~/.config/nixos-dotfiles#kakxem --argstr desktop "hyprland"
```

### Available desktop options

- `gnome` – GNOME with GDM
- `hyprland` – Hyprland with GDM
- `kde` – KDE Plasma 6 (display manager not yet configured)
- `cosmic` – COSMIC (not yet implemented)

## Adding new desktop modules

1. Create a new directory under `modules/desktops/` (e.g., `cosmic`).
2. Add a `default.nix` for system‑level services and packages, using `lib.mkIf (config.desktop == "cosmic")`.
3. Optionally add a `home.nix` for user‑level settings.
4. Update `modules/desktop/default.nix` to import the new module.
5. Update the `desktopHomeModules` mapping in `core/home.nix` if a home configuration exists.

The configuration will automatically include the appropriate modules when the `desktop` argument is set.
