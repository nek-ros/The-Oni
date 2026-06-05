# Noctalia — apenas o pacote de sistema
# O homeModule (programs.noctalia) foi movido para ~/.config/home-manager/home.nix

{ inputs, pkgs, ... }:

{
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
