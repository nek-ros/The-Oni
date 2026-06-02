# Configuração principal do sistema

{
  config,
  stable,
  unstable,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./amd-gpu.nix
    ./linuxtoys-otmz.nix
    ./mounts.nix
    ./h510-headset.nix
    ./experimental.nix
    ./desktop.nix
    ./audio.nix
    ./packages.nix
    ./fonts.nix
    ./flatpak.nix
    ./maintenance.nix
    ./mango.nix
    ./noctalia.nix
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader
  boot.supportedFilesystems = [ "xfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Rede
  networking.hostName = "nekachine";
  networking.networkmanager.enable = true;

  # Fuso horário e locale
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Usuário
  users.users.nek = {
    isNormalUser = true;
    description = "nek";
    extraGroups = [
      "networkmanager"
      "wheel"
      "root"
      "input"
      "video"
      "audio"
      "seat"
      "podman"
      "docker"
    ];
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="258a", ATTRS{idProduct}=="0049", TAG+="uaccess", MODE="0666"
  '';

  nixpkgs.config.allowUnfree = true;

  services.gnome.gnome-keyring.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  system.stateVersion = "26.05";
}
