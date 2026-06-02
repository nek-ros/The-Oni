{
  description = "Home Manager — nek";

  inputs = {
    nixpkgs.url        = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/d5f311962825c2610c280b7cc3049d8f1dda534";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, noctalia, spicetify-nix, ... }:
    let
      system   = "x86_64-linux";
      unstable = import nixpkgs        { inherit system; config.allowUnfree = true; };
      stable   = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
    in {
      homeConfigurations.nek = home-manager.lib.homeManagerConfiguration {
        pkgs = unstable;

        extraSpecialArgs = {
          inherit noctalia spicetify-nix stable unstable;
        };

        modules = [ ./home.nix ];
      };
    };
}
