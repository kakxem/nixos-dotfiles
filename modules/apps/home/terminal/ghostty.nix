#
# Ghostty
#
{ palette, palettes, ... }:

let
  p = palettes.${palette};
in
{
  programs = {
    ghostty = {
      enable = true;
      settings = {
        "font-family" = "FiraCode Nerd Font";
        "font-size" = 21;

        # Ghostty's `palette` needs one `N=#color` entry per line (a list here;
        # Home Manager writes each list element on its own line). Do NOT join
        # them with ':' — Ghostty rejects the compact single-line form.
        "background" = p.bg;
        "foreground" = p.fg;
        "selection-background" = p.bg1;
        "selection-foreground" = p.fg;
        "cursor-color" = p.accent;
        "cursor-text" = p.bg;
        "palette" = [
          "0=${p.bg}"
          "1=${p.red}"
          "2=${p.green}"
          "3=${p.yellow}"
          "4=${p.blue}"
          "5=${p.magenta}"
          "6=${p.cyan}"
          "7=${p.fg}"
          "8=${p.comment}"
          "9=${p.red}"
          "10=${p.green}"
          "11=${p.yellow}"
          "12=${p.blue}"
          "13=${p.magenta}"
          "14=${p.cyan}"
          "15=${p.white}"
        ];
      };
    };
  };
}
