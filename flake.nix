{
  description = "Kakxem nixos flake";
  
  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    # override the default substituters
    substituters = [
      "https://cache.nixos.org"

      # nix community's cache server
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                  # Change to stable if you want

    home-manager = {                                                      # User Package Management
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

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
    in
    {
      nixosConfigurations = {

        # Main configuration
        desktopConfig = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit pkgs user kde2nix;
          };
          
          modules = [
            # Import configuration
            ./core/configuration.nix

            # Home Manager
            home-manager.nixosModules.home-manager {             
              home-manager.extraSpecialArgs = {
                inherit pkgs user hyprland;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${user} = import ./core/home.nix;
            }

            {
	      nix.settings.trusted-users = [ user ];
	    }
          ];
        };
        # End of main configuration

      };
    };
}

