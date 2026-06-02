# Manutenção: garbage collection e auto-upgrade

{ inputs, ... }:

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
    flake       = "/etc/nixos";
    dates       = "daily";
    allowReboot = false;  # true = reinicia automaticamente se necessário
  };
}
