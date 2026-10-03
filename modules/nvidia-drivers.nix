
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
  specialisation.egpu.configuration = {
    system.nixos.tags = ["egpu"];

systemd.services.wait-for-nvidia-egpu = {
  description = "Wait for NVIDIA eGPU DRM device";
  wantedBy = [ "graphical.target" ];
  before = [ "graphical.target" ];

  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.bash}/bin/bash -c 'for i in {1..30}; do [ -e /dev/dri/nvidia-card ] && exit 0; sleep 1; done; echo \"NVIDIA eGPU DRM device did not appear\"; exit 1'";
  };
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
      open = false;
    };
    boot.kernelParams = [ 
      "pci=realloc"
      "thunderbolt.clx=0"
    ];
  };
}
