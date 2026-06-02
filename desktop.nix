# Desktop: tuigreet, Mango, teclado, portais, Steam, gamemode

{ unstable, stable, ... }:

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

  xdg.portal = {
    enable = true;
    extraPortals = [ unstable.kdePackages.xdg-desktop-portal-kde ];
    xdgOpenUsePortal = true;
  };

  # Variáveis de hardware — nível de sistema
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };

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
  programs.nix-ld = {
    enable = true;
    # libraries = [ ... ]; opcional
  };

  users.users.nek.shell = unstable.zsh;
}
