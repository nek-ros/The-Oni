# NixOS module: H510-PRO Wireless Headset — WirePlumber + ALSA fix
# O serviço systemd de usuário (§4) foi movido para ~/.config/home-manager/home.nix

{ config, lib, pkgs, ... }:

{
  # ── 1. Regras WirePlumber 0.5 ───────────────────────────────────────────────
  environment.etc."wireplumber/wireplumber.conf.d/99-h510.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            device.name = "alsa_card.usb-XiiSound_Technology_Corporation_H510-PRO_Wireless_headset-00"
          }
        ]
        actions = {
          update-props = {
            api.alsa.soft-mixer = true
            api.alsa.ignore-dB  = true
          }
        }
      }
    ]

    node.rules = [
      {
        matches = [
          {
            node.name = "~alsa_output.*H510.*"
          }
        ]
        actions = {
          update-props = {
            node.volume = 1.0
            node.mute   = false
          }
        }
      }
    ]
  '';

  # ── 2. Script de volume ALSA ────────────────────────────────────────────────
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "h510-volume" ''
      sleep 2
      CARD=$(${pkgs.alsa-utils}/bin/aplay -l 2>/dev/null \
             | grep -i "H510" \
             | grep -oP "card \K[0-9]+" \
             | head -1)
      [ -z "$CARD" ] && exit 0
      ${pkgs.alsa-utils}/bin/amixer -c "$CARD" cset numid=9 100,100 &>/dev/null || true
      ${pkgs.alsa-utils}/bin/amixer -c "$CARD" cset numid=10 100    &>/dev/null || true
      ${pkgs.alsa-utils}/bin/amixer -c "$CARD" cset numid=7  on,on  &>/dev/null || true
      ${pkgs.alsa-utils}/bin/amixer -c "$CARD" cset numid=8  on     &>/dev/null || true
    '')
  ];

  # ── 3. Regra udev ───────────────────────────────────────────────────────────
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="sound", \
    ATTRS{idVendor}=="040b", ATTRS{idProduct}=="0897", \
    RUN+="${pkgs.bash}/bin/bash -c 'sleep 2; ${pkgs.alsa-utils}/bin/aplay -l 2>/dev/null | grep -i H510 | grep -oP \"card \\K[0-9]+\" | head -1 | xargs -I{} ${pkgs.alsa-utils}/bin/amixer -c {} cset numid=9 100,100'"
  '';

  # ── 5. Persistência ALSA ────────────────────────────────────────────────────
  hardware.alsa.enablePersistence = true;
}
