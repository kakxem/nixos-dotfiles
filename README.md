# Kakxem's NixOS Dotfiles

## Overview
This repository contains a modular NixOS configuration managed as a **Flake**. It provides a reproducible environment with support for multiple desktop environments and a clean separation between system-level and user-level configurations.

## How it Works
The configuration is designed to be highly modular and easy to customize:

1.  **Centralized Variables (`vars.nix`)**: All user-specific info (name, email) and system toggles (architecture, supported desktops) are defined here.
2.  **SpecialArgs**: These variables are passed from `flake.nix` to every module, allowing them to adapt dynamically (e.g., using `${user}` everywhere).
3.  **Modular Structure**:
    - **`core/`**: The entry points. `system.nix` defines the OS structure, and `home.nix` defines the user environment.
    - **`modules/config/`**: Low-level system configurations (Boot, Hardware, Services).
    - **`modules/apps/`**: Package lists divided into `system` (NixOS) and `home` (Home Manager).
    - **`modules/desktops/`**: Specific configurations for different desktop environments.

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
│   │   └── services/     # System services, Fonts & Rebuild scripts
│   └── desktops/         # Desktop-specific modules (GNOME, Hyprland, KDE)
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

# Give execution permission and run the install script
sudo chmod +x ./scripts/install.sh
sudo ./scripts/install.sh
```

---

## Management & Rebuilding

The system provides two convenience commands to apply changes:

- **`rebuild-system`**: Rebuilds the NixOS system configuration (requires sudo).
- **`rebuild-home`**: Rebuilds the Home Manager configuration.

### Switching Desktops
Both scripts accept a `DESKTOP` environment variable to choose the environment (default is `gnome`):

```bash
DESKTOP=hyprland rebuild-system
DESKTOP=hyprland rebuild-home
```

### Manual Rebuild
You can also use the standard Nix commands:
```bash
# System rebuild
sudo nixos-rebuild switch --flake .#system-hyprland

# Home Manager rebuild
home-manager switch --flake .#kakxem-hyprland
```

## Available Desktops
- **GNOME**: Stable and feature-complete.
- **Hyprland**: Highly customized Wayland compositor.
- **KDE Plasma**: Modern desktop experience (WIP).
- **COSMIC**: Next-gen Rust-based desktop (WIP).
