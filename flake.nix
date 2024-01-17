{
  description = "Kakxem nixos flake";
  
  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    # will be appended to the system-level substituters
    extra-substituters = [
      # nix community's cache server
      "https://nix-community.cachix.org"
    ];

    # will be appended to the system-level trusted-public-keys
    extra-trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
    hyprland.url = "github:hyprwm/Hyprland";

    # Kde2nix (Temporal plasma 6)
    kde2nix.url = "github:nix-community/kde2nix";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, hyprland, kde2nix }: 
    let
      # These are values that are passed to the nixos flake
      user = "kakxem";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations."desktopConfig" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs user kde2nix hyprland;
        };

        modules = [
          # Import configuration
          ./core/configuration.nix

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
        ];
      };

      homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit pkgs user kde2nix hyprland;
        };
        modules = [
          ./core/home.nix
        ];
      };

      packages.${system}."${user}" = self.homeConfigurations."${user}".activationPackage;
    };
}

