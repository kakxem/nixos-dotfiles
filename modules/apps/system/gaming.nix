#
# Gaming
#

{
  lib,
  pkgs,
  gpu,
  user,
  ...
}:

let
  nvtopPackage =
    {
      amd = pkgs.nvtopPackages.amd;
      nvidia = pkgs.nvtopPackages.nvidia;
      nvidia-open = pkgs.nvtopPackages.nvidia;
      intel = pkgs.nvtopPackages.intel;
    }
    .${gpu} or null;

  shaderCacheEnv =
    lib.optionalAttrs
      (builtins.elem gpu [
        "amd"
        "intel"
      ])
      {
        MESA_SHADER_CACHE_MAX_SIZE = "12G";
      }
    //
      lib.optionalAttrs
        (builtins.elem gpu [
          "nvidia"
          "nvidia-open"
        ])
        {
          __GL_SHADER_DISK_CACHE_SIZE = "12000000000";
        };
in
{
  environment.systemPackages =
    with pkgs;
    [
      wineWow64Packages.base

      # Tools
      r2modman
      mangohud
      gamescope
    ]
    ++ lib.optionals (nvtopPackage != null) [
      nvtopPackage
    ]
    ++ lib.optionals (gpu == "amd") [
      lact
    ];

  environment.variables = {
    PROTON_ENABLE_WAYLAND = 1;
    PROTON_ENABLE_HDR = 1;
    PROTON_FSR4_UPGRADE = 1;
    ENABLE_LAYER_MESA_ANTI_LAG = 1;
    MANGOHUD = 1;
  }
  // shaderCacheEnv;

  programs = {
    # Needed to succesfully start Steam
    # Steam shader pre-caching is intentionally left as a manual client setting.
    # Recommended: Steam -> Settings -> Downloads -> disable both:
    # - Enable Shader Pre-caching
    # - Allow background processing of Vulkan shaders
    # Driver shader caches remain enabled and are sized via environment.variables.
    steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    # -- Gamemode installation --
    #
    # *Steam* : Right-click game - Properties - Launch options: gamemoderun %command%
    #
    # *Lutris* : General Preferences - Enable Feral GameMode - Global options - Add Environment Variables:
    # LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
    #
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 4;
        };
        gpu = lib.mkIf (gpu == "amd") {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1;
          amd_performance_level = "high";
        };
      };
    };
  };
  users.users."${user}".extraGroups = [ "gamemode" ];

  hardware.xone.enable = true; # Xbox controller support
  services.lact.enable = gpu == "amd"; # Enable lact
}
