# Noctalia — apenas o pacote de sistema
# O homeModule (programs.noctalia) foi movido para ~/.config/home-manager/home.nix

{ config, stable, unstable, lib, inputs, pkgs, ... }:

{
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
