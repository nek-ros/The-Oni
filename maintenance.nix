# Manutenção: garbage collection e auto-upgrade

{ ... }:

{
  # Garbage collection automático
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 15d";
  };

  # Auto-upgrade do sistema
  system.autoUpgrade = {
    enable      = true;
    flake       = "/home/nek/.config/home-manager";
    dates       = "daily";
    allowReboot = false;  # true = reinicia automaticamente se necessário
  };
}
