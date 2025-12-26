{ pkgs, ... }:

let
  # Direct reference to the folder you found
  a4k = "${pkgs.anime4k}";
in
{
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq"; # Recommended for shaders
      gpu-api = "vulkan"; # or "opengl"
      hwdec = "auto-safe";
    };

    bindings = {
      # Updated path: removing 'share/anime4k' since the store path points directly to files
      "CTRL+1" =
        "no-osd change-list glsl-shaders set \"${a4k}/Anime4K_Clamp_Highlights.glsl:${a4k}/Anime4K_Restore_CNN_M.glsl:${a4k}/Anime4K_Upscale_CNN_x2_M.glsl\"; show-text \"Anime4K: Mode A (Fast)\"";
      "CTRL+0" = "no-osd change-list glsl-shaders clr \"\"; show-text \"Shaders Cleared\"";
    };
  };
}
