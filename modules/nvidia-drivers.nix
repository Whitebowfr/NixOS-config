
{ lib, pkgs, config, inputs, ... }:
with lib;
let
  cfg = config.drivers.intel;
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = config.nixpkgs.config.allowUnfree or false;
  };
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  #specialisation.egpu.configuration = {
  #  system.nixos.tags = ["egpu"];

systemd.services.wait-for-nvidia-egpu = {
  description = "Wait for NVIDIA eGPU DRM device";
  wantedBy = [ "graphical.target" ];
  before = [ "graphical.target" ];
};
    boot.initrd.kernelModules = [ "nvidia" ];
    boot.kernelModules = [ 
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    services.xserver.videoDrivers = [ "modesetting" "nvidia"];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
    };
    boot.kernelParams = [ 
      "pci=realloc"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      "thunderbolt.clx=0"
    ];
  #};
}
