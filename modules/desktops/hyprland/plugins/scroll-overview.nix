{
  lib,
  cmake,
  fetchFromGitHub,
  hyprland,
  lua5_4,
  mkHyprlandPlugin,
}:
mkHyprlandPlugin (finalAttrs: {
  pluginName = "scrolloverview";
  version = "0-unstable-2026-11-05";

  # Build against the caller's Hyprland, not the top-level one: the session uses
  # the flake's Hyprland and the plugin ABI must match it.
  inherit hyprland;

  src = fetchFromGitHub {
    owner = "yayuuu";
    repo = "hyprland-scroll-overview";
    rev = "3eb62e3e0093d54cbdcf4f58c831b5b53b3b1ff2";
    hash = "sha256-0mBYt+dkLeXonsVLKs8mfsNbMQ1Zqvzf0r8VOteXni4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ lua5_4 ];

  # The version header is generated at build time; reproduce it without git.
  env.SCROLLOVERVIEW_BUILD_VERSION = finalAttrs.version;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/yayuuu/hyprland-scroll-overview";
    description = "Niri-like scrolling overview plugin for Hyprland";
    license = lib.licenses.gpl3;
    inherit (hyprland.meta) platforms;
  };
})
