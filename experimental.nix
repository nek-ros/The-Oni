# Configuração e Ativação de algumas funcionalidades

{ inputs, ... }:
{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
  ];
  trusted-public-keys = [
  ];
  };
}
