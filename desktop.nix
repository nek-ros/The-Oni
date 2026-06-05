# Desktop: tuigreet, Mango, teclado, portais, Steam, gamemode

{
  pkgs,
  unstable,
  stable,
  ...
}:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${stable.tuigreet}/bin/tuigreet --cmd mango";
      };
    };
    useTextGreeter = true;
  };

  services.xserver.enable = true;
  services.xserver.excludePackages = [ unstable.xterm ];
  security.polkit.enable = true;

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Variáveis de ambiente — nível de sistema
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    NIXOS_OZONE_WL = "1";
  };

  # Força NIXOS_OZONE_WL no systemd user manager
  systemd.user.extraConfig = ''
    DefaultEnvironment=NIXOS_OZONE_WL=1
  '';

  # Gaming
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
  programs.gamemode.enable = true;

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  # Portais — necessário em nível NixOS pros systemd services rodarem
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr # ← adiciona esse
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "wlr"; # ← prioriza wlr
  };

  programs.nix-ld = {
    enable = true;
    # libraries = [ ... ]; opcional
  };

  users.users.nek.shell = unstable.zsh;
}
