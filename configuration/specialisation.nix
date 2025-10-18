{
  config,
  ...
}:
{
  specialisation = {
    egpu.configuration = {
      boot.initrd.kernelModules = [
        "thunderbolt"
        "usbhid"
        "joydev"
        "xpad"
        "nvidia"
      ];
      boot.kernelModules = [
        "thunderbolt"
        "usbhid"
        "joydev"
        "xpad"
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
        "amdgpu"
        "kvm-intel"
      ];
      services.xserver.videoDrivers = [
        "nvidia"
        "modesetting"
        "fbdev"
      ];
      hardware.nvidia = {

        modesetting.enable = true;
        powerManagement.enable = false;

        powerManagement.finegrained = false;

        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          nvidiaBusId = "PCI:45:0:0";
          intelBusId = "PCI:0:2:0";
        };
      };
    };
    igpu.configuration = {
      boot.kernelModules = [
        "thunderbolt"
        "usbhid"
        "joydev"
        "xpad"
        "kvm-intel"
      ];
      services.xserver.videoDrivers = [
        "modesetting"
        "fbdev"
      ];
      boot.initrd.kernelModules = [
        "thunderbolt"
        "usbhid"
        "joydev"
        "xpad"
      ];
    };
  };
}
