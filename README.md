# Kakxem's NixOS Dotfiles

## Overview
This repository contains a modular NixOS configuration managed as a **Flake**. It provides a reproducible environment with support for multiple desktop environments and a clean separation between system-level and user-level configurations.

## How it Works
The configuration is designed to be highly modular and easy to customize:

1.  **Centralized Variables (`vars.nix`)**: All user-specific info (name, email) and system toggles (architecture, desktop environment, GPU vendor) are defined here.
2.  **SpecialArgs**: These variables are passed from `flake.nix` to every module, allowing them to adapt dynamically (e.g., using `${user}` and `${desktop}` everywhere).
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
│   └── desktops/         # Desktop-specific modules (GNOME, Hyprland, KDE, Niri)
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

# Review vars.nix and adjust the user, Git identity, system, and desktop before installing
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

The system provides two convenience commands to apply changes:

- **`rebuild-system`**: Rebuilds the NixOS system configuration (requires sudo).
- **`rebuild-home`**: Rebuilds the Home Manager configuration (standalone, no sudo required).

*Note: This repository uses a **Flake-based standalone** setup for Home Manager. The `home-manager` CLI is installed system-wide during `rebuild-system`, so `rebuild-home` works immediately after the system is installed. `rebuild-home` runs `home-manager switch -b backup`, so replaced Home Manager files are backed up with the `backup` extension.*

### Switching Desktops
The desktop environment is managed through the `desktop` variable in `vars.nix`. 

To switch environments:
1.  Edit `vars.nix` and set `desktop` to one of: `"gnome"`, `"hyprland"`, `"kde"`, or `"niri"`.
2.  Run the rebuild scripts to apply changes:

```bash
rebuild-system
rebuild-home
```

### Hardware Selection
The GPU vendor is managed through the `gpu` variable in `vars.nix`.

Set `gpu` to one of: `"amd"`, `"nvidia"`, `"nvidia-open"`, `"intel"`, or `"none"`.

- `"amd"`: enables AMDGPU early KMS and AMD-specific tools like LACT.
- `"nvidia"`: enables the proprietary NVIDIA driver with modesetting.
- `"nvidia-open"`: enables the open NVIDIA kernel module with modesetting for supported newer GPUs.
- `"intel"`: enables the modesetting driver and Intel media acceleration packages.
- `"none"`: skips vendor-specific GPU configuration.

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
