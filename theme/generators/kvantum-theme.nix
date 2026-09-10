# Generates a stable Kvantum/KDE theme from the active palette.
#
{ pkgs, palette, palettes, kdeColors ? "" }:

let
  p = palettes.${palette};
  themeName = "custom-theme";
  catppuccinBase = pkgs.catppuccin-kvantum;
  sourceDir = "${catppuccinBase}/share/Kvantum/catppuccin-frappe-blue";

  # Map Catppuccin Frappe colors to semantic palette roles.
  colorMap = [
    { from = "#303446"; to = p.bg; }       # window / view background
    { from = "#292C3C"; to = p.bg; }       # mantle / recessed surface
    { from = "#414559"; to = p.bg1; }      # raised button surface
    { from = "#51576D"; to = p.comment; }  # borders / muted controls
    { from = "#626880"; to = p.fg_idle; }  # disabled text / menu marker
    { from = "#C6D0F5"; to = p.fg; }       # primary text
    { from = "#8CAAEE"; to = p.accent; }   # primary accent
    { from = "#98B2EF"; to = p.blue; }     # visited/link blue
    { from = "#839EDD"; to = p.blue; }     # blue control detail
    { from = "#A5ADCE"; to = p.fg_idle; }  # secondary icon detail
    { from = "#949CBB"; to = p.fg_idle; }  # inactive tab text
    { from = "#737994"; to = p.comment; }  # subtle separator detail
    { from = "#E78284"; to = p.red; }
    { from = "#CA9EE6"; to = p.magenta; }
  ];

  colorSedArgs = builtins.concatStringsSep " " (
    map (c: "-e 's/${c.from}/${c.to}/g'") colorMap
  );

  # Use readable text for persistent ItemView selections.
  itemViewTextArgs =
    "-e '/^\\[ItemView\\]/,/^\\[/ s/text\\.press\\.color=[^\\n]*/text.press.color=${p.white}/'"
    + " -e '/^\\[ItemView\\]/,/^\\[/ s/text\\.toggle\\.color=[^\\n]*/text.toggle.color=${p.white}/'"
    + " -e '/^\\[ItemView\\]/a text.focus.color=${p.fg}'";

  highlightTextArgs =
    "-e 's/highlight\\.text\\.color=${p.fg}/highlight.text.color=${p.white}/'"
    + " -e '/^highlight\\.text\\.color=${p.white}$/a inactive.highlight.text.color=${p.white}'"
    + " -e 's/highlight\\.color=${p.accent}4D/highlight.color=${p.accent}/'"
    + " -e 's/inactive\\.highlight\\.color=${p.comment}/inactive.highlight.color=${p.accent}/'";

  # Prevent the desktop palette from overriding theme selections.
  generalArgs =
    "-e 's/respect_DE=true/respect_DE=false/'"
    + " " + highlightTextArgs
    + " " + itemViewTextArgs;

  # Make pressed and toggled ItemView selections more visible.
  activeItemViewSvgArgs =
    "-e '/id=\\\"itemview-toggled-left\\\"/,/id=\\\"toolbar-normal-top\\\"/ s/opacity:0\\.25;fill:${p.accent}/opacity:0.72;fill:${p.accent}/g'"
    + " -e '/id=\\\"itemview-pressed-left\\\"/,/id=\\\"splitter-grip-focused\\\"/ s/opacity:0\\.25;fill:${p.accent}/opacity:0.72;fill:${p.accent}/g'";

  kdeColorsText = kdeColors;
in
pkgs.stdenv.mkDerivation {
  pname = "kvantum-custom-theme";
  version = "1.0.0";
  src = null;
  dontBuild = true;
  dontConfigure = true;
  unpackPhase = "true";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/Kvantum/${themeName}" "$out/share/color-schemes"

    sed ${colorSedArgs} ${activeItemViewSvgArgs} \
      "${sourceDir}/catppuccin-frappe-blue.svg" \
      > "$out/share/Kvantum/${themeName}/${themeName}.svg"

    sed ${colorSedArgs} ${generalArgs} \
      "${sourceDir}/catppuccin-frappe-blue.kvconfig" \
      > "$out/share/Kvantum/${themeName}/${themeName}.kvconfig"

    cat > "$out/share/color-schemes/${themeName}.colors" <<'EOF'
${kdeColorsText}
EOF
    cp "$out/share/color-schemes/${themeName}.colors" \
      "$out/share/Kvantum/${themeName}/${themeName}.colors"

    runHook postInstall
  '';
}
