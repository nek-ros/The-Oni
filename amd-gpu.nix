# Ativação e configuração do AMD-GPU

{
  unstable,
  ...
}:

{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.enableRedistributableFirmware = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "uinput" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
    "amdgpu.freesync_video=1"
    "amd_pstate=active"
  ];

  # Só OpenCL — Vulkan já vem pelo Mesa/RADV
  hardware.graphics.extraPackages = with unstable; [
    rocmPackages.clr
    mesa
    libva
    libvdpau
    libva-vdpau-driver
  ];

  # LIBVA_DRIVER_NAME de hardware fica aqui (nível de sistema)
  # A mesma variável no home.nix cobre a sessão do usuário
  environment.variables.LIBVA_DRIVER_NAME = "radeonsi";

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="cpu", ATTR{cpufreq/energy_performance_preference}="balance_performance"
  '';
}
