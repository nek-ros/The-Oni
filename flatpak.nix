# Flatpak e apps instalados via Flatpak-nix

{ ... }:

{
  services.flatpak = {
    enable   = true;
    packages = [
      "fr.handbrake.ghb"
      "org.fedoraproject.MediaWriter"
      "com.github.tchx84.Flatseal"
      "io.github.flattool.Warehouse"
      "com.ranfdev.DistroShelf"
      "io.github.kolunmi.Bazaar"
    ];
    update.auto = {
      enable     = true;
      onCalendar = "daily";
    };
  };
}
