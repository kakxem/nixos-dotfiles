#
# Screenshot and OCR helpers for the wlr-protocol Wayland desktops
#
# grim, slurp and satty need wlr-screencopy and wlr-layer-shell. KWin and
# Mutter lack both, so only niri, hyprland and umbriel import this.
#

{ pkgs, ... }:

let
  tesseract = pkgs.tesseract5.override {
    enableLanguages = [
      "eng"
      "spa"
    ];
  };

  # Full output, saved and copied.
  full = pkgs.writeShellApplication {
    name = "screenshot-full";
    runtimeInputs = with pkgs; [
      coreutils
      grim
      libnotify
      wl-clipboard
    ];
    text = ''
      mkdir -p "$HOME/Pictures/Screenshots"
      filename="$HOME/Pictures/Screenshots/$(date '+Screenshot From %Y-%m-%d %H-%M-%S.png')"
      grim "$filename"
      wl-copy --type image/png < "$filename"
      notify-send "Saved and copied to clipboard: $filename"
    '';
  };

  # Capture first, then crop on the frozen image inside satty.
  region = pkgs.writeShellApplication {
    name = "screenshot-region";
    runtimeInputs = with pkgs; [
      coreutils
      grim
      satty
      wl-clipboard
    ];
    text = ''
      mkdir -p "$HOME/Pictures/Screenshots"
      filename="$HOME/Pictures/Screenshots/$(date '+Screenshot From %Y-%m-%d %H-%M-%S.png')"
      grim -t ppm - | satty --filename - --fullscreen all --initial-tool crop \
        --output-filename "$filename" --copy-command wl-copy --save-after-copy --early-exit all
    '';
  };

  ocr = pkgs.writeShellApplication {
    name = "screenshot-ocr";
    runtimeInputs = with pkgs; [
      grim
      libnotify
      slurp
      tesseract
      wl-clipboard
    ];
    text = ''
      grim -g "$(slurp -d)" - | tesseract stdin stdout | wl-copy
      notify-send "OCR: texto copiado al portapapeles"
    '';
  };
in
{
  home.packages = [
    full
    region
    ocr
  ];
}
