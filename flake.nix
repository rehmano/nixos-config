{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      mkSystem =
        {
          hostname,
          stateVersion,
          user ? "rehmans",
          system ? "x86_64-linux",
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}
            {
              system.stateVersion = stateVersion;
              networking.hostName = hostname;
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit self inputs hostname;
              };
              home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
              home-manager.users.${user} = {
                imports = [ ./users/${user}/home.nix ];
                home.stateVersion = stateVersion;
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      nixosConfigurations = {
        rocinante = mkSystem {
          hostname = "rocinante";
          stateVersion = "25.11";
        };

        arboghast = mkSystem {
          hostname = "arboghast";
          stateVersion = "25.11";
        };
      };
    };
}
