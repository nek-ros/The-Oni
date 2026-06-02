# Fontes do sistema

{ stable, ... }:

{
  fonts.packages = with stable; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.meslo-lg
    nerd-fonts.inconsolata
    nerd-fonts.noto
    nerd-fonts.roboto-mono
    nerd-fonts.ubuntu-mono
    nerd-fonts.iosevka
    nerd-fonts.symbols-only  # só ícones, sem fonte base
    nerd-fonts.adwaita-mono
    nerd-fonts.mononoki
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    cantarell-fonts
    poppins

  ];

  fonts.fontconfig.cache32Bit = true;
}
