# Kakxem's NixOS Dotfiles

## Overview
This repository contains a modular NixOS configuration managed as a **Flake**. It provides a reproducible environment with support for multiple desktop environments and a clean separation between system-level and user-level configurations.

## How it Works
The configuration is designed to be highly modular and easy to customize:

1.  **Centralized Variables (`vars.nix`)**: All user-specific info (name, email) and system choices (architecture, desktop environment, GPU vendor, color palette) are defined here.
2.  **SpecialArgs**: These variables are passed from `flake.nix` to every module, allowing them to adapt dynamically (e.g., using `${user}` and `${desktop}` everywhere).
3.  **Modular Structure**:
    - **`core/`**: The entry points. `system.nix` defines the OS structure, and `home.nix` defines the user environment.
    - **`modules/config/`**: Low-level system configurations (Boot, Hardware, Services).
    - **`modules/apps/`**: Package lists divided into `system` (NixOS) and `home` (Home Manager).
    - **`modules/desktops/`**: Specific configurations for different desktop environments.
    - **`theme/`**: Shared color palettes and generators for palette-driven themes and icons.

---

## Repository Structure
```text
.
├── flake.nix             # Flake logic and entry points
├── vars.nix              # Central control panel (User & System variables)
├── core/
│   ├── system.nix        # Main NixOS entry point
│   └── home.nix          # Main Home Manager entry point
├── modules/
│   ├── apps/
│   │   ├── system/       # System-level packages (NixOS)
│   │   └── home/         # User-level packages & configs (Home Manager)
│   ├── config/
│   │   ├── system/       # Core OS (Boot, Users, Locale, etc.)
│   │   ├── hardware/     # Drivers & Generated hardware configs
│   │   ├── services/     # System services, Fonts & Rebuild scripts
│   │   └── theming/      # System and Home Manager theme integration
│   └── desktops/         # Desktop-specific modules (GNOME, Hyprland, KDE, Niri)
├── theme/
│   ├── palettes.nix      # Shared semantic color palettes
│   └── generators/       # Themes and icons generated from the active palette
├── scripts/
│   └── install.sh        # Initial installation script
└── wallpapers/           # System wallpapers
```

---

## Installation
To install this configuration on a fresh NixOS system:

```sh
# Enter a temporary shell with git
nix-shell -p git

# Clone the repository
git clone https://github.com/kakxem/nixos-dotfiles.git ~/.config/nixos-dotfiles

# Leave the temporary nix-shell and go back to your normal shell
exit

# Go to dotfiles
cd ~/.config/nixos-dotfiles

# Review vars.nix and adjust the user, Git identity, system, desktop, GPU, and palette
$EDITOR vars.nix

# Give execution permission and run the install script
sudo chmod +x ./scripts/install.sh
sudo ./scripts/install.sh

# Reboot into the new system generation
reboot
```

The installer shows the current `vars.nix` values, asks for confirmation, installs the system generation for the next boot, and activates Home Manager with backups. It does not switch the live system, so rebooting is required to complete the installation.

---

## Management & Rebuilding

Rebuilds run through [`nix-rebuild`](https://github.com/kakxem/nix-rebuild), a terminal UI that runs the NixOS and Home Manager switches, streams Nix's output and records every run so it can be read back later. This repository consumes it as a flake input and declares its options in `modules/apps/home/terminal/nix-rebuild.nix` (the checkout and the names of both configurations), so the commands need no arguments:

```sh
nix-rebuild home      # build and switch the Home Manager configuration
nix-rebuild system    # build and switch the NixOS system
nix-rebuild update    # refresh flake.lock, build both, then activate both
nix-rebuild runs      # list recorded runs, read a log or delete one
nix-rebuild locks     # put a saved flake.lock back and rebuild with it
```

`nix-rebuild home` runs as your regular user. `nix-rebuild system` re-executes itself under `sudo`, so its whole interface runs as root.

*Note: The older `rebuild-system` and `rebuild-home` scripts are still installed from `modules/config/services/scripts.nix`. They are legacy scripts, but they still work if `nix-rebuild` breaks or something else fails.*

### Switching Desktops
The desktop environment is managed through the `desktop` variable in `vars.nix`. 

To switch environments:
1.  Edit `vars.nix` and set `desktop` to one of: `"gnome"`, `"hyprland"`, `"kde"`, or `"niri"`.
2.  Apply the change with the rebuild commands:

```bash
nix-rebuild system
nix-rebuild home
```

### Hardware Selection
The GPU vendor is managed through the `gpu` variable in `vars.nix`.

Set `gpu` to one of: `"amd"`, `"nvidia"`, `"nvidia-open"`, `"intel"`, or `"none"`.

- `"amd"`: enables AMDGPU early KMS and AMD-specific tools like LACT.
- `"nvidia"`: enables the proprietary NVIDIA driver with modesetting.
- `"nvidia-open"`: enables the open NVIDIA kernel module with modesetting for supported newer GPUs.
- `"intel"`: enables the modesetting driver and Intel media acceleration packages.
- `"none"`: skips vendor-specific GPU configuration.

### Changing the Color Palette
The shared color palette is selected through the `palette` variable in `vars.nix`.

Available palettes are: `"ayu"`, `"gruvbox"`, `"onedark"`, `"dracula"`, `"nord"`, `"osaka-jade"`, `"catppuccin-mocha"`, `"tokyo-night-storm"`, and `"everforest"`.

The selected palette is applied to supported desktop, terminal, editor, shell, and application themes. After changing it, rebuild the Home Manager configuration:

```bash
nix-rebuild home
```

### Manual Rebuild
You can also use the standard Nix commands:
```bash
# System rebuild
sudo nixos-rebuild switch --flake .#system

# Home Manager rebuild
home-manager switch --flake .#<user-from-vars.nix>
```

## Available Desktops
- **GNOME**: Stable and feature-complete.
- **Hyprland**: Highly customized Wayland compositor.
- **KDE Plasma**: Modern desktop experience.
- **Niri**: Scrollable-tiling Wayland compositor.
