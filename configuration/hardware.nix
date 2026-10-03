{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ]; # TODO : check if this is needed

  hardware.firmware = [ pkgs.sof-firmware ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "sdhci_pci" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/02fffffe-5088-4669-ae88-66fff0cefe89";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };
  
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/02fffffe-5088-4669-ae88-66fff0cefe89";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/02fffffe-5088-4669-ae88-66fff0cefe89";
    fsType = "btrfs";
    options = [ "subvol=swap" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/02fffffe-5088-4669-ae88-66fff0cefe89";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/679B-1C1B";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 16 * 1024;
  }];
  boot.resumeDevice = "/dev/disk/by-uuid/02fffffe-5088-4669-ae88-66fff0cefe89";
  boot.kernelParams = [
    "resume_offset=131071"
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  services.hardware.bolt.enable = true;
}
