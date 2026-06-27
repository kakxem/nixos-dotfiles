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
  };
}
