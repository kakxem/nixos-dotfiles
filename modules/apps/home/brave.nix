# Keep Brave Origin's toolkit and profile theme on Qt.
{ config, pkgs, ... }:

let
  braveOriginQt = pkgs.brave-origin.override {
    commandLineArgs = "--ui-toolkit=qt";
  };

  braveOriginLauncher = pkgs.writeShellScript "brave-origin-qt-launcher" ''
    brave_preferences=${pkgs.lib.escapeShellArg "${config.home.homeDirectory}/.config/BraveSoftware/Brave-Origin/Default/Preferences"}
    brave_profile_dir="$(${pkgs.coreutils}/bin/dirname "$brave_preferences")"
    brave_uid="$(${pkgs.coreutils}/bin/id -u)"

    # Update the profile only while Brave Origin is not running.
    if ! ${pkgs.procps}/bin/pgrep -u "$brave_uid" -x brave-origin >/dev/null 2>&1; then
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

    exec ${braveOriginQt}/bin/brave-origin "$@"
  '';

  braveOriginWithQtTheme = pkgs.symlinkJoin {
    name = "brave-origin-with-qt-theme";
    paths = [ braveOriginQt ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm "$out/bin/brave-origin"
      makeWrapper ${braveOriginLauncher} "$out/bin/brave-origin"

      # Route desktop entries through the profile-aware launcher.
      for brave_desktop in "$out"/share/applications/*.desktop; do
        brave_desktop_source="$(${pkgs.coreutils}/bin/readlink -f "$brave_desktop")"
        rm "$brave_desktop"
        ${pkgs.gnused}/bin/sed \
          "s|${braveOriginQt}/bin/brave-origin|$out/bin/brave-origin|g" \
          "$brave_desktop_source" > "$brave_desktop"
      done
    '';
    meta = braveOriginQt.meta;
  };
in
{
  home.packages = [ braveOriginWithQtTheme ];
}
