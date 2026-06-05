# Áudio: PipeWire + ALSA + PulseAudio compat
# H510 headset config incluída aqui

{ pkgs, lib, stable, ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;

  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    package           = stable.pipewire;
    wireplumber.package = stable.wireplumber;
  };

  # H510 headset — soft-mixer + volume restore via udev
  environment.etc."wireplumber/wireplumber.conf.d/99-h510.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          { device.name = "alsa_card.usb-XiiSound_Technology_Corporation_H510-PRO_Wireless_headset-00" }
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
          { node.name = "~alsa_output.*H510.*" }
        ]
        actions = {
          update-props = {
            node.volume  = 1.0
            node.mute    = false
          }
        }
      }
    ]
  '';

  services.udev.extraRules = lib.mkAfter (let
    h510-volume = pkgs.writeShellApplication {
      name = "h510-volume";
      runtimeInputs = [ stable.alsa-utils ];
      text = ''
        sleep 2
        CARD=$(aplay -l 2>/dev/null \
          | grep -i "H510" \
          | grep -oP 'card \K[0-9]+' \
          | head -1)
        [ -z "$CARD" ] && exit 0
        amixer -c "$CARD" cset numid=9 100,100 &>/dev/null || true
        amixer -c "$CARD" cset numid=10 100    &>/dev/null || true
        amixer -c "$CARD" cset numid=7  on,on  &>/dev/null || true
        amixer -c "$CARD" cset numid=8  on     &>/dev/null || true
      '';
    };
  in ''
    ACTION=="add", SUBSYSTEM=="sound", ATTRS{idVendor}=="040b", ATTRS{idProduct}=="0897", RUN+="${h510-volume}/bin/h510-volume"
  '');
}
