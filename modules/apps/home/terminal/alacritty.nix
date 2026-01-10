#
# Alacritty
#

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = {
          # Font - Laptop has size manually changed at home.nix
          normal.family = "FiraCode Nerd Font";
          bold = {
            style = "Bold";
          };
          size = 21;
        };
        window.decorations = "none";
      };
    };
  };
}
