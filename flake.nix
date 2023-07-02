{
  description = "Kakxem nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                  # Change to stable if you want

    nur = {                                                               # NUR Packages
      url = "github:nix-community/NUR";                                   # Add "nur.nixosModules.nur" to the host modules
    };

    home-manager = {                                                      # User Package Management
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {                                                          # Official Hyprland flake
      url = "github:vaxerski/Hyprland";                                   # Add "hyprland.nixosModules.default" to the host modules
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, hyprland, nur }: 
    let
      # Editable
      user = "kakxem";
      location = "$HOME/.setup";

      # Don't touch
      system = "x86_64-linux";                                  # System architecture
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;                              # Allow proprietary software
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        kakxemConfig = lib.nixosSystem {                               # Desktop profile
          inherit system;
          specialArgs = {
            inherit inputs pkgs system user location;
            host = {
              hostName = "desktop";
              mainMonitor = "HDMI-A-1";
            };
          };                                                      # Pass flake variable

          modules = [                                             # Modules that are used.
            nur.nixosModules.nur
            ./core/configuration.nix

            home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit pkgs user;
                host = {
                  hostName = "desktop";
                  mainMonitor = "HDMI-A-1";
                };
              };                                                  # Pass flake variable

              home-manager.users.${user} = {
                imports = [
                  ./core/home.nix
                ];
              };
            }
          ];
        };
      };
    };
}

