{ pkgs, inputs, ... }:

{
  home.packages = [
    (inputs.opencode.packages.${pkgs.system}.default.overrideAttrs (old: {
      preBuild = (old.preBuild or "") + ''
        sed -i -E 's#"packageManager": "bun@[^"]+"#"packageManager": "bun@${pkgs.bun.version}"#' package.json
      '';
    }))
  ];

  xdg.configFile."opencode/AGENTS.md".text = ''
    # Development Environment

    I am using NixOS. If a program I need is not available, you can run it via Nix
    (for example with `nix shell` or another suitable Nix command).

    # Dotfiles

    My NixOS dotfiles are located at `~/.config/nixos-dotfiles`.
    Use that repository as the source of truth for system packages, Home Manager apps,
    scripts, desktop modules, and managed configuration files.

    If I ask to add a program, script, service, desktop setting, or system config,
    start by searching in `~/.config/nixos-dotfiles` instead of editing
    generated files directly.

    # Git

    Do not commit changes unless I explicitly request a commit.

    # Managed Files

    If I ask you to update this user `AGENTS.md`, modify `~/.config/nixos-dotfiles/modules/apps/home/opencode/default.nix` instead of editing `~/.config/opencode/AGENTS.md` directly. The file is managed by Home Manager, and direct edits will be overwritten by `rebuild-home`.
  '';
}
