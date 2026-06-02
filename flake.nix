{
  description = "NixOS + Home Manager — nek";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    preload-ng.url = "github:miguel-b-p/preload-ng";

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/fde14b1ec3ec72bb0abb5c5ce19f177dda0442f1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      nix-flatpak,
      preload-ng,
      mangowm,
      noctalia,
      spicetify-nix,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      unstable = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.nek = home-manager.lib.homeManagerConfiguration {
        pkgs = unstable;

        extraSpecialArgs = {
          inherit
            noctalia
            spicetify-nix
            stable
            unstable
            ;
        };

        modules = [ ./home.nix ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          nix-flatpak.nixosModules.nix-flatpak
          mangowm.nixosModules.mango
          preload-ng.nixosModules.default

          { _module.args = { inherit inputs unstable stable; }; }
        ];
      };
    };
}
