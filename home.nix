# Home Manager — nek
# ~/.config/home-manager/home.nix
#
# Aplique com: home-manager switch --flake .

{ pkgs, lib, config, stable, unstable, noctalia, spicetify-nix, ... }: {
  # ── Identidade ──────────────────────────────────────────────────────────────
  home.username      = "nek";
  home.homeDirectory = "/home/nek";
  home.stateVersion  = "26.05";

  # ── Noctalia homeModule ─────────────────────────────────────────────────────
  imports = [
    noctalia.homeModules.default
    spicetify-nix.homeManagerModules.default
  ];

  programs.noctalia.enable = true;
  services.gnome-keyring.enable = true;


  # ── Spicetify ───────────────────────────────────────────────────────────────

  programs.spicetify =
    let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;
      theme = spicePkgs.themes.starryNight;
      colorScheme = "Base";
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
        fullAppDisplay
        volumePercentage
        songStats
      ];
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
        newReleases
      ];
    };

  # ── Pacotes pessoais ────────────────────────────────────────────────────────
  home.packages = [
    # Utilitários
    stable.git
    stable.fastfetch
    stable.terminal-toys
    stable.pipes
    stable.nixd
    stable.nil
    stable.libsecret

    # Spicetify CLI
    stable.spicetify-cli

    # Dev
    stable.python3
    stable.python3Packages.pip
    stable.podman
    stable.devbox

    # Editores
    stable.vscode
    stable.zed-editor

    # Desktop / UI'
    stable.mission-center
    stable.adwaita-icon-theme
    stable.nwg-look
    stable.adw-gtk3
    stable.kdePackages.dolphin
    stable.kdePackages.qt6ct
    stable.libsForQt5.qt5ct
    stable.kdePackages.kcolorscheme
    stable.kdePackages.partitionmanager

    # Terminais
    stable.alacritty
    stable.foot

    # Multimídia
    stable.discord

    # Gaming
    stable.prismlauncher
    unstable.protonplus
    stable.faugus-launcher

    # Captura / gravação
    stable.hyprshot
    stable.gpu-screen-recorder

    # Distrobox
    stable.distrobox

    # Fontes
    stable.nerd-fonts.fira-code
    stable.nerd-fonts.jetbrains-mono
    stable.nerd-fonts.hack
    stable.nerd-fonts.meslo-lg
    stable.nerd-fonts.inconsolata
    stable.nerd-fonts.noto
    stable.nerd-fonts.roboto-mono
    stable.nerd-fonts.ubuntu-mono
    stable.nerd-fonts.iosevka
    stable.nerd-fonts.symbols-only
    stable.nerd-fonts.adwaita-mono
    stable.nerd-fonts.mononoki
    stable.noto-fonts
    stable.noto-fonts-cjk-sans
    stable.noto-fonts-color-emoji
    stable.liberation_ttf
    stable.cantarell-fonts
    stable.poppins
  ];

  # ── Fontconfig ──────────────────────────────────────────────────────────────
  fonts.fontconfig.enable = true;

  # ── Cursor ──────────────────────────────────────────────────────────────────
  home.pointerCursor = {
    name    = "Adwaita";
    package = stable.adwaita-icon-theme;
    size    = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # ── Portals ──────────────────────────────────────────────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };


  # ── Variáveis de sessão ─────────────────────────────────────────────────────
  home.sessionVariables = {
    # Cursor
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE  = "24";

    # Wayland
    NIXOS_OZONE_WL = "1";
    GTK_CSD        = "0";

    # Qt
    QT_QPA_PLATFORM                     = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # GPU / Mesa
    LIBVA_DRIVER_NAME          = "radeonsi";
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };

  # ── Zsh ─────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll      = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      trash   = "sudo nix-collect-garbage -d";
      hm       = "home-manager switch";
      update-flake = "nix flake update noctalia --flake ~/.config/home-manager/flake.nix && home-manager switch --flake .";
    };
    enableCompletion          = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;
  };

  # ── Starship ────────────────────────────────────────────────────────────────
  programs.starship.enable = true;

  # ── Serviço systemd de usuário: H510 headset ────────────────────────────────
  # (§4 do h510-headset.nix — as partes com root ficam no nixos/h510-headset.nix)
  systemd.user.services.h510-volume = {
    Unit = {
      Description = "H510 headset ALSA volume restore";
      After       = [ "pipewire-pulse.service" ];
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type            = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "h510-volume" ''
        sleep 3
        CARD=$(${stable.alsa-utils}/bin/aplay -l 2>/dev/null \
               | grep -i "H510" \
               | grep -oP 'card \K[0-9]+' \
               | head -1)
        [ -z "$CARD" ] && exit 0
        ${stable.alsa-utils}/bin/amixer -c "$CARD" cset numid=9 100,100 &>/dev/null || true
        ${stable.alsa-utils}/bin/amixer -c "$CARD" cset numid=10 100    &>/dev/null || true
        ${stable.alsa-utils}/bin/amixer -c "$CARD" cset numid=7  on,on  &>/dev/null || true
        ${stable.alsa-utils}/bin/amixer -c "$CARD" cset numid=8  on     &>/dev/null || true
      '';
    };
  };

  # ── home-manager gerencia a si mesmo ────────────────────────────────────────
  programs.home-manager.enable = true;
}
