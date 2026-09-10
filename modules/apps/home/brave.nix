# Keep Brave's toolkit and profile theme on Qt.
{ config, pkgs, ... }:

let
  braveQt = pkgs.brave.override {
    commandLineArgs = "--ui-toolkit=qt";
  };

  braveLauncher = pkgs.writeShellScript "brave-qt-launcher" ''
    brave_preferences=${pkgs.lib.escapeShellArg "${config.home.homeDirectory}/.config/BraveSoftware/Brave-Browser/Default/Preferences"}
    brave_profile_dir="$(${pkgs.coreutils}/bin/dirname "$brave_preferences")"
    brave_uid="$(${pkgs.coreutils}/bin/id -u)"

    # Update the profile only while Brave is not running.
    if ! ${pkgs.procps}/bin/pgrep -u "$brave_uid" -x brave >/dev/null 2>&1; then
      ${pkgs.coreutils}/bin/mkdir -p "$brave_profile_dir"

      if [ -f "$brave_preferences" ]; then
        brave_preferences_tmp="$(${pkgs.coreutils}/bin/mktemp --tmpdir="$brave_profile_dir" .Preferences.XXXXXX)"
        if ${pkgs.jq}/bin/jq '.extensions.theme.system_theme = 2' \
          "$brave_preferences" > "$brave_preferences_tmp"; then
          ${pkgs.coreutils}/bin/chmod --reference="$brave_preferences" "$brave_preferences_tmp"
          ${pkgs.coreutils}/bin/mv "$brave_preferences_tmp" "$brave_preferences"
        else
          ${pkgs.coreutils}/bin/rm -f "$brave_preferences_tmp"
        fi
      else
        ${pkgs.coreutils}/bin/printf '%s\n' \
          '{"extensions":{"theme":{"system_theme":2}}}' > "$brave_preferences"
        ${pkgs.coreutils}/bin/chmod 600 "$brave_preferences"
      fi
    fi

    exec ${braveQt}/bin/brave "$@"
  '';

  braveWithQtTheme = pkgs.symlinkJoin {
    name = "brave-with-qt-theme";
    paths = [ braveQt ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm "$out/bin/brave"
      makeWrapper ${braveLauncher} "$out/bin/brave"

      # Route desktop entries through the profile-aware launcher.
      for brave_desktop in "$out"/share/applications/*.desktop; do
        brave_desktop_source="$(${pkgs.coreutils}/bin/readlink -f "$brave_desktop")"
        rm "$brave_desktop"
        ${pkgs.gnused}/bin/sed \
          "s|${braveQt}/bin/brave|$out/bin/brave|g" \
          "$brave_desktop_source" > "$brave_desktop"
      done
    '';
    meta = braveQt.meta;
  };
in
{
  home.packages = [ braveWithQtTheme ];
}
