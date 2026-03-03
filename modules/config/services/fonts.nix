{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    noto-fonts-cjk-sans
    adwaita-fonts
    noto-fonts
    noto-fonts-color-emoji
  ];
}
