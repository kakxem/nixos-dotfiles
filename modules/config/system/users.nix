{ pkgs, user, ... }:

{
  # Enable fish (It'll be used for root user)
  programs.fish.enable = true;

  # Enable git
  programs.git.enable = true;

  # User configs
  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
    ];
    shell = pkgs.fish;
  };
}
