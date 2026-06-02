# Áudio: PipeWire + ALSA + PulseAudio compat

{ stable, ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;

  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    package           = stable.pipewire;      # ← fixa no stable
    wireplumber.package = stable.wireplumber; # ← fixa o wireplumber também
    # jack.enable     = true;
  };
}
