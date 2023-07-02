#
# ZSH
#

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;            # Auto suggest options and highlights syntax, searches in history for options
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      # histSize = 100000;

      shellAliases = {
        xapps = "xlsclients";
      };

      initExtra = ''
        source ~/.p10k.zsh
      '';

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
    };
  };
}
