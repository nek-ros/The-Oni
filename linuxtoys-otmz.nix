# Otimização direta do LinuxToys com auditação

{ stable, ... }:

{
  # Scheduler
  services.scx = {
    enable    = true;
    scheduler = "scx_pandemonium";
  };

  hardware.block.defaultScheduler = "kyber";

  # Ananicy — prioridade de processos
  services.ananicy = {
    enable        = true;
    package       = stable.ananicy-cpp;
    rulesProvider = stable.ananicy-rules-cachyos;
  };

  # EarlyOOM — mata processos antes de travar o sistema
  services.earlyoom = {
    enable            = true;
    freeSwapThreshold = 2;
    freeMemThreshold  = 2;
    extraArgs = [
      "-g" "--avoid" "'^(X|plasma.*|konsole|kwin|wayland|gnome.*|mangowm.*|noctalia.*)$'"
    ];
  };

  # Preload
  services.preload-ng = {
    enable = true;
    settings = {
      cycle        = 5;
      memTotal     = -5;
      memFree      = 70;
      memCached    = 10;
      memBuffers   = 50;
      minSize      = 1000000;
      processes    = 60;
      sortStrategy = 0;
      autoSave     = 1800;
      mapPrefix    = "/nix/store/;/run/current-system/;!/";
      exePrefix    = "/nix/store/;/run/current-system/;!/";
    };
  };

  zramSwap = {
    enable        = true;
    algorithm     = "zstd";
    memoryPercent = 50;
  };

  # vm.min_free_kbytes dinâmico (1% da RAM total)
  systemd.services.set-min-free-mem = {
    description = "Set vm.min_free_kbytes dynamically";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "local-fs.target" ];
    serviceConfig = {
      User            = "root";
      RemainAfterExit = true;
    };
    script = ''
      TOTAL_MEM=$(${stable.gawk}/bin/awk '/MemTotal/ {printf "%.0f", $2 * 0.01}' /proc/meminfo)
      if [ -z "$TOTAL_MEM" ] || [ "$TOTAL_MEM" -eq 0 ]; then
        echo "Failed to calculate memory size" >&2
        exit 1
      fi
      ${stable.procps}/bin/sysctl -w vm.min_free_kbytes=$TOTAL_MEM
    '';
  };
}
