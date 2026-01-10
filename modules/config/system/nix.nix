{ ... }:

{
  # Nix config
  nix = {
    settings = {
      auto-optimise-store = true; # Optimise syslinks
      experimental-features = [
        "nix-command"
        "flakes"
      ]; # ** Flakes **
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
