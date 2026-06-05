# Montagem do SSD de Jogos

{ ... }:

{
  # ── TRIM semanal ────────────────────────────────────────────────────────────
  services.fstrim = {
    enable   = true;
    interval = "weekly";
  };

  # ── Sysctl: menos pressão sobre o SSD ───────────────────────────────────────
  boot.kernel.sysctl = {
    "vm.swappiness"          = 10;   # quase nunca usa swap em disco
    "vm.vfs_cache_pressure"  = 50;   # mantém mais cache de inodes/dentries
    "vm.dirty_ratio"         = 10;   # começa a escrever com 10 % de RAM suja
    "vm.dirty_background_ratio" = 5; # escrita em background a partir de 5 %
  };

  # ── /tmp na RAM ──────────────────────────────────────────────────────────────
  boot.tmp = {
    useTmpfs  = true;
    tmpfsSize = "8G"; # ajuste conforme sua RAM disponível
  };

 # ─────────────────────────────────────────────


 fileSystems."/mnt/Games" = {
    device  = "/dev/disk/by-label/Games";
    fsType  = "xfs";
    options = [
      "noatime"
      "nofail"
   ];
  };
}
