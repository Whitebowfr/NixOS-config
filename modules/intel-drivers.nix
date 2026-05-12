# 💫 https://github.com/JaKooLit 💫 #

{ lib, pkgs, config, inputs, ... }:
with lib;
let
  cfg = config.drivers.intel;
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
    #nixpkgs.config.packageOverrides = pkgs: {
    #  vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    #};

    # OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      package = pkgs-hyprland.mesa;
      package32 = pkgs-hyprland.pkgsi686Linux.mesa;

      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
	      intel-compute-runtime
        vulkan-loader
        vulkan-validation-layers
      ];

      extraPackages32 = with pkgs; [
        vulkan-loader
      ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

    services.thermald.enable = true;
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


    boot.initrd.kernelModules = [ "i915" ];
    boot.kernelModules = [ "kvm-intel" ];
    services.xserver.videoDrivers = [ "modesetting" ];
    boot.kernelParams = [ 
      "i915.enable_guc=3" 
      #"i915.force_probe=46a6" 
      "i915.enable_psr=0" 
    ];
}
