{
  description = "Kakxem nixos flake";
  
  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    # will be appended to the system-level substituters
    extra-substituters = [
      # nix community's cache server
      "https://nix-community.cachix.org"

      # Hyprland
      "https://hyprland.cachix.org"
    ];

    # will be appended to the system-level trusted-public-keys
    extra-trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

      # Hyprland
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    # Change to stable if you want
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # User Package Management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs =  inputs @ { self, nixpkgs, home-manager, ...}: 
    let
      # These are values that are passed to the nixos flake
      user = "kakxem";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations."desktop" = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        specialArgs = {
          inherit user inputs;
        };

        modules = [
          # Import cache
          {
            nix.settings.trusted-users = [ user ];
            # the system-level substituers & trusted-public-keys
            nix.settings = {
              substituters = [
                "https://cache.nixos.org"
              ];

              trusted-public-keys = [
                # the default public key of cache.nixos.org, it's built-in, no need to add it here
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              ];
            };
          }

          # Import configuration
          ./core/configuration.nix
        ];
      };

      homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit pkgs user inputs;
        };
        modules = [
          ./core/home.nix
        ];
      };

      packages.${system}."${user}" = self.homeConfigurations."${user}".activationPackage;
    };
}

