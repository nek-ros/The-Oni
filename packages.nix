# Pacotes do sistema — disponíveis para todos os usuários
# Pacotes pessoais do nek estão em ~/.config/home-manager/home.nix

{ unstable, pkgs, ... }:

{
  environment.systemPackages = with unstable; [
    # Ferramentas de GPU / monitoramento (precisam de acesso a hardware)
    corectrl
    lm_sensors
    radeontop
    vulkan-tools
    mesa-demos
  ];
}
