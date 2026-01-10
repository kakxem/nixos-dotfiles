{ pkgs, ... }:

let
  a4k = "${pkgs.anime4k}";
in
{
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      gpu-api = "vulkan";
      hwdec = "auto-safe";

      # Default: Ultra Quality Mode A
      glsl-shaders = "${a4k}/Anime4K_Clamp_Highlights.glsl:${a4k}/Anime4K_Restore_CNN_UL.glsl:${a4k}/Anime4K_Upscale_CNN_x2_UL.glsl:${a4k}/Anime4K_AutoDownscalePre_x2.glsl:${a4k}/Anime4K_AutoDownscalePre_x4.glsl:${a4k}/Anime4K_Upscale_CNN_x2_M.glsl";
    };

    bindings = {
      # Mode A (Ultra) - The Gold Standard for 1080p -> 4K
      "CTRL+1" =
        "no-osd change-list glsl-shaders set \"${a4k}/Anime4K_Clamp_Highlights.glsl:${a4k}/Anime4K_Restore_CNN_UL.glsl:${a4k}/Anime4K_Upscale_CNN_x2_UL.glsl:${a4k}/Anime4K_AutoDownscalePre_x2.glsl:${a4k}/Anime4K_AutoDownscalePre_x4.glsl:${a4k}/Anime4K_Upscale_CNN_x2_M.glsl\"; show-text \"Anime4K: Mode A (Ultra)\"";

      # Mode B (Ultra Soft) - For older anime with heavy compression artifacts
      "CTRL+2" =
        "no-osd change-list glsl-shaders set \"${a4k}/Anime4K_Clamp_Highlights.glsl:${a4k}/Anime4K_Restore_CNN_Soft_UL.glsl:${a4k}/Anime4K_Upscale_CNN_x2_UL.glsl\"; show-text \"Anime4K: Mode B (Ultra Soft)\"";

      # Mode C (Ultra Sharp) - For high-quality 1080p Blurays
      "CTRL+3" =
        "no-osd change-list glsl-shaders set \"${a4k}/Anime4K_Clamp_Highlights.glsl:${a4k}/Anime4K_Upscale_CNN_x2_UL.glsl\"; show-text \"Anime4K: Mode C (Ultra Sharp)\"";

      # The "Everything" Mode - Deep Reconstruction + Line Thinning + Darkening
      # This makes the anime look like a modern high-budget movie.
      "CTRL+9" =
        "no-osd change-list glsl-shaders set \"${a4k}/Anime4K_Clamp_Highlights.glsl:${a4k}/Anime4K_Restore_CNN_UL.glsl:${a4k}/Anime4K_Upscale_CNN_x2_UL.glsl:${a4k}/Anime4K_Restore_CNN_Soft_L.glsl:${a4k}/Anime4K_Thin_HQ.glsl:${a4k}/Anime4K_Darken_HQ.glsl\"; show-text \"Anime4K: Cinematic Ultra\"";

      # Clear
      "CTRL+0" = "no-osd change-list glsl-shaders clr \"\"; show-text \"Shaders Cleared\"";
    };
  };
}
