## Overview
Add a new Home Manager module to enable Ghostty alongside Alacritty, with only font family and size configured to match the existing Alacritty settings. Keep the change minimal so Ghostty can be evaluated safely before any migration.

## Architecture
- Add `modules/apps/home/terminal/ghostty.nix` and import it from `modules/apps/home/terminal/default.nix`.
- Keep `modules/apps/home/terminal/alacritty.nix` enabled for parallel usage.

## Components & Settings
- Enable `programs.ghostty`.
- Set font family and size to match Alacritty:
  - family: `FiraCode Nerd Font`
  - size: `21`

## Data Flow & Overrides
- Configuration is managed entirely in Home Manager module.
- Future per-host overrides can be placed in `home.nix` to match the existing Alacritty override pattern.

## Error Handling & Testing
- No runtime logic changes; failures would be configuration errors during evaluation.
- Verify via Home Manager activation and launching Ghostty to confirm font rendering.
