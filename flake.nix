{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      home-manager,
      nixos-hardware,
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
            }
            # Pin easyeffects to 8.1.4, 8.15 breaks Kodi sound
            # https://github.com/wwmm/easyeffects/issues/4914#issuecomment-4076352342
            {
              nixpkgs.overlays = [
                (final: prev: {
                  easyeffects = prev.easyeffects.overrideAttrs (old: {
                    version = "8.1.4";
                    src = prev.fetchFromGitHub {
                      owner = "wwmm";
                      repo = "easyeffects";
                      rev = "v8.1.4";
                      hash = "sha256-0/xbvmj7p8JE3aH84SrcEf8kr+0X1KgHMRkBca+2rtY=";
                    };
                  });
                })
              ];
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
          extraModules = [ nixos-hardware.nixosModules.framework-amd-ai-300-series ];
        };
      };
    };
}
