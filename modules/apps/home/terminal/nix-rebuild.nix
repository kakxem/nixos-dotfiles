{ config, inputs, ... }:

{
  imports = [ inputs.nix-rebuild.homeManagerModules.default ];

  programs.nix-rebuild = {
    enable = true;
    checkout = "${config.home.homeDirectory}/.config/nixos-dotfiles";
    system = {
      config = "system";
    };
    home = {
      config = config.home.username;
      manager = "standalone";
    };
  };
}
