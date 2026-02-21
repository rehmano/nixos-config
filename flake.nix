{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs =
    {
      chaotic,
      home-manager,
      nixpkgs,
      self,
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
              networking.domain = "freighter.internal";
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit self inputs hostname;
              };
              home-manager.users.${user} = {
                imports = [
                  ./users/${user}/home.nix
                ];
                home.stateVersion = stateVersion;
                home.username = user;
                home.homeDirectory = "/home/${user}";
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
          extraModules = [
            chaotic.nixosModules.default
            {
              nix.settings.substituters = [
                "https://nix-gaming.cachix.org"
              ];
              nix.settings.trusted-public-keys = [
                "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
              ];
            }
          ];
        };
      };
    };
}
