# Home Manager — nek
# ~/.config/home-manager/home.nix
#
# Aplique com: home-manager switch --flake . / /  = hm

{
  pkgs,
  stable,
  unstable,
  noctalia,
  spicetify-nix,
  ...
}:
{
  # ── Identidade ──────────────────────────────────────────────────────────────
  home.username = "nek";
  home.homeDirectory = "/home/nek";
  home.stateVersion = "26.05";

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
    in
    {
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
  home.packages =
    (with stable; [
      # Utilitários
      git
      fastfetch
      terminal-toys
      pipes
      nixd
      nil
      libsecret
      nixfmt
      gh

      # Spicetify CLI
      spicetify-cli

      # Dev
      python3
      python3Packages.pip
      podman
      devbox
      eza

      # Desktop / UI'
      mission-center
      adwaita-icon-theme
      nwg-look
      adw-gtk3
      kdePackages.dolphin
      kdePackages.qt6ct
      libsForQt5.qt5ct
      kdePackages.kcolorscheme
      kdePackages.partitionmanager

      # Terminais
      alacritty
      foot

      # Distrobox
      distrobox

      # Fontes
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.meslo-lg
      nerd-fonts.inconsolata
      nerd-fonts.noto
      nerd-fonts.roboto-mono
      nerd-fonts.ubuntu-mono
      nerd-fonts.iosevka
      nerd-fonts.symbols-only
      nerd-fonts.adwaita-mono
      nerd-fonts.mononoki
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      cantarell-fonts
      poppins
    ])
    ++ (with unstable; [
      # Editores
      neovim
      vscode
      zed-editor

      # Multimídia / redes
      discord
      brave

      # Gaming
      heroic
      prismlauncher
      protonplus
      faugus-launcher

      # Captura
      hyprshot
      gpu-screen-recorder
    ]);

  # ── Fontconfig ──────────────────────────────────────────────────────────────
  fonts.fontconfig.enable = true;

  # ── Cursor ──────────────────────────────────────────────────────────────────
  home.pointerCursor = {
    name = "Adwaita";
    package = stable.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # ── Variáveis de sessão ─────────────────────────────────────────────────────
  home.sessionVariables = {
    NIX_PATH = "nixpkgs=channel:nixos-unstable";

    # Cursor
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";

    # Wayland
    NIXOS_OZONE_WL = "1";
    GTK_CSD = "0";
    XDG_CURRENT_DESKTOP = "MangoWM";

    # Qt
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # GPU / Mesa
    LIBVA_DRIVER_NAME = "radeonsi";
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };

  # ── Zsh ─────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -la";
      vim = "nvim";
      vi = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/home-manager#nixos";
      trash = "sudo nix-collect-garbage -d";
      hm = "home-manager switch";
      update-flake = "nix flake update --flake /home/nek/.config/home-manager && home-manager switch --flake /home/nek/.config/home-manager";
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = [
      "rm *"
      "pkill *"
      "cp *"
    ];

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # ── Oh-My-Zsh ────────────────────────────────────────────────────────────────
  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "z"
      "aliases"
      "eza"
      "gh"

    ];
    theme = "gozilla";
  };

  # ── Starship ────────────────────────────────────────────────────────────────
  programs.starship.enable = true;

  # ── home-manager gerencia a si mesmo ────────────────────────────────────────
  programs.home-manager.enable = true;
}
