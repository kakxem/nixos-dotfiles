{ pkgs, ... }:

{
  imports = [
    # ./alacritty.nix
    ./ghostty.nix
    ./fish.nix
    ./git.nix
    ./btop.nix
    ./hermes.nix
    ./opencode.nix
  ];

  home.packages = with pkgs; [
    fzf # fuzzy finder (Ctrl+R history, file search)
    zoxide # smart cd
    eza # modern ls (with git status)
    fd # modern find
    bat # modern cat (syntax highlighting)
  ];
}
