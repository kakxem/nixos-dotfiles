{
  description = "Kakxem nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                  # Change to stable if you want

    home-manager = {                                                      # User Package Management
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager }: 
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
            inherit pkgs user;
          };

          modules = [
            # Import configuration
            ./core/configuration.nix

            # Home Manager
            home-manager.nixosModules.home-manager {             
              home-manager.extraSpecialArgs = {
                inherit pkgs user;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${user} = import ./core/home.nix;
            }
          ];
        };
        # End of main configuration

      };
    };
}

