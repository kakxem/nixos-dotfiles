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

      # Niri
      "https://niri.cachix.org"
    ];

    # will be appended to the system-level trusted-public-keys
    extra-trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

      # Hyprland
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="

      # Niri
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  inputs = {
    # Change to stable if you want
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # User Package Management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    # DMS
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DMS plugins (community registry)
    "dms-plugin-registry" = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      vars = import ./vars.nix;

      # Use system from vars
      system = vars.system;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };

      # Helper function to create a NixOS configuration
      mkNixosConfig =
        desktop:
        nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = {
            inherit inputs pkgs-stable;
          } // vars;

          modules = [
            # Import cache
            {
              nix.settings.trusted-users = [ vars.user ];
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
            ./core/system.nix
          ];
        };

      # Helper function to create a Home Manager configuration
      mkHomeConfig =
        desktop:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit pkgs inputs pkgs-stable;
          } // vars;
          modules = [
            ./core/home.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        # Default config (from vars)
        "system" = mkNixosConfig vars.desktop;
      };

      homeConfigurations = {
        # Default config (from vars)
        "${vars.user}" = mkHomeConfig vars.desktop;
      };

      packages.${system}."${vars.user}" = self.homeConfigurations."${vars.user}".activationPackage;
    };
}
