{ ... }:

{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Enable wayland for electron

    # Enable VA-API for Firefox
    MOZ_DISABLE_RDD_SANDBOX = "1";
    EGL_PLATFORM = "wayland";
    LIBVA_MESSAGING_LEVEL = "1";
  };
}
