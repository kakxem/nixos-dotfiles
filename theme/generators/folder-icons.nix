# theme/generators/folder-icons.nix
#
# Palette-driven GTK and KDE folder-icon overlays.
{ pkgs, palette, palettes }:

let
  p = palettes.${palette};
  themeName = "custom-theme";
  kdeThemeName = "custom-theme-kde";
  sourceDir = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
  breezeSourceDir = "${pkgs.kdePackages.breeze-icons}/share/icons/breeze";

  hexDigit = c:
    if c == "a" then 10 else if c == "b" then 11 else
    if c == "c" then 12 else if c == "d" then 13 else
    if c == "e" then 14 else if c == "f" then 15 else
    builtins.fromJSON c;
  hexPairToInt = pair:
    hexDigit (builtins.substring 0 1 pair) * 16
    + hexDigit (builtins.substring 1 1 pair);
  intToHex = value:
    let
      digits = [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ];
      high = builtins.div value 16;
      low = value - high * 16;
    in
      builtins.elemAt digits high + builtins.elemAt digits low;
  mixChannel = weight: foreground: background:
    builtins.div (foreground * weight + background * (100 - weight)) 100;
  mix = weight: foreground: background:
    let
      channel = color: offset:
        hexPairToInt (builtins.substring offset 2 color);
    in
      "#"
      + intToHex (mixChannel weight (channel foreground 1) (channel background 1))
      + intToHex (mixChannel weight (channel foreground 3) (channel background 3))
      + intToHex (mixChannel weight (channel foreground 5) (channel background 5));

  # Keep folder bodies subdued and emblems bright.
  folderFront = p.folder;
  folderBack = mix 72 folderFront p.bg1;
  folderHighlight = mix 18 p.fg folderFront;
  folderHighlightStrong = mix 30 p.fg folderFront;
  emblem = p.fg0;
in
pkgs.runCommand "custom-theme-icons" {
  nativeBuildInputs = [ pkgs.gtk4 ];
}
  ''
    destination="$out/share/icons/${themeName}"
    kde_destination="$out/share/icons/${kdeThemeName}"
    mkdir -p "$destination/scalable/places" "$kde_destination"

    for icon in \
      "${sourceDir}/scalable/places"/folder*.svg \
      "${sourceDir}/scalable/places/user-desktop.svg" \
      "${sourceDir}/scalable/places/user-home.svg"; do
      sed \
        -e '0,/#438de6/s//#${builtins.substring 1 6 folderBack}/' \
        -e 's/#438de6/${emblem}/g' \
        -e 's/#62a0ea/${folderFront}/g' \
        -e 's/#a4caee/${folderFront}/g' \
        -e 's/#afd4ff/${folderHighlightStrong}/g' \
        -e 's/#c0d5ea/${folderHighlight}/g' \
        "$icon" > "$destination/scalable/places/$(basename "$icon")"
    done

    # Override Breeze folder colors without replacing the rest of the theme.
    for size in 16 22 24 32 48 64 96; do
      source_places="${breezeSourceDir}/places/$size"
      target_places="$kde_destination/places/$size"
      mkdir -p "$target_places"

      for icon in "$source_places"/*folder*.svg "$source_places/user-home.svg"; do
        test -e "$icon" || continue
        sed \
          -e '/\.ColorScheme-Text/,/}/ s/color:#[0-9a-fA-F]\{6\}/color:${emblem}/' \
          -e '/\.ColorScheme-Accent/,/}/ s/color:#[0-9a-fA-F]\{6\}/color:${folderFront}/' \
          -e 's/ColorScheme-Text/CustomFolderText/g' \
          -e 's/ColorScheme-Accent/CustomFolder/g' \
          -e 's/#4183d7/${folderFront}/g' \
          "$icon" > "$target_places/$(basename "$icon")"
      done

      # Dolphin resolves ordinary directories through this MIME icon.
      target_mimetypes="$kde_destination/mimetypes/$size"
      mkdir -p "$target_mimetypes"
      cp "$target_places/folder.svg" "$target_mimetypes/inode-directory.svg"
      if test -e "$target_places/folder-symbolic.svg"; then
        cp "$target_places/folder-symbolic.svg" \
          "$target_mimetypes/inode-directory-symbolic.svg"
      fi
    done

    cat > "$destination/index.theme" <<'EOF'
    [Icon Theme]
    Name=Custom Theme
    Comment=Palette-driven Adwaita folder icons
    Inherits=Adwaita,hicolor
    Directories=scalable/places

    [scalable/places]
    Context=Places
    Size=128
    MinSize=8
    MaxSize=512
    Type=Scalable
    EOF

    gtk4-update-icon-cache --force "$destination"

    cat > "$kde_destination/index.theme" <<'EOF'
    [Icon Theme]
    Name=Custom Theme KDE
    Comment=Palette-driven Breeze folder icons
    Inherits=breeze-dark,breeze,hicolor
    Directories=places/16,places/22,places/24,places/32,places/48,places/64,places/96,mimetypes/16,mimetypes/22,mimetypes/24,mimetypes/32,mimetypes/48,mimetypes/64,mimetypes/96

    [places/16]
    Size=16
    Context=Places
    Type=Fixed

    [places/22]
    Size=22
    Context=Places
    Type=Fixed

    [places/24]
    Size=24
    Context=Places
    Type=Fixed

    [places/32]
    Size=32
    Context=Places
    Type=Fixed

    [places/48]
    Size=48
    Context=Places
    Type=Fixed

    [places/64]
    Size=64
    Context=Places
    Type=Fixed

    [places/96]
    Size=96
    Context=Places
    Type=Fixed

    [mimetypes/16]
    Size=16
    Context=MimeTypes
    Type=Fixed

    [mimetypes/22]
    Size=22
    Context=MimeTypes
    Type=Fixed

    [mimetypes/24]
    Size=24
    Context=MimeTypes
    Type=Fixed

    [mimetypes/32]
    Size=32
    Context=MimeTypes
    Type=Fixed

    [mimetypes/48]
    Size=48
    Context=MimeTypes
    Type=Fixed

    [mimetypes/64]
    Size=64
    Context=MimeTypes
    Type=Fixed

    [mimetypes/96]
    Size=96
    Context=MimeTypes
    Type=Fixed
    EOF

    gtk4-update-icon-cache --force "$kde_destination"
  ''
