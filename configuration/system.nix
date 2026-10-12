
{ config, pkgs, host, username, options, lib, system, inputs, ... }:
let
in {
  imports = [
    ./hardware.nix
    ./user.nix
    ./packages.nix
#    ./specialisation.nix
    ./quickshell.nix
    ./terminal.nix
    ./localization.nix
    ../modules/intel-drivers.nix
    ../modules/nvidia-drivers.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages;

    kernelModules = [
        "thunderbolt"
        "usbhid"
        "joydev"
        "xpad"
      ];

    kernelParams = [
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" # this is to mask that stupid 1.5 mins systemd bug
      "nowatchdog"
      "modprobe.blacklist=sp5100_tco" # watchdog for AMD
      "modprobe.blacklist=iTCO_wdt" # watchdog for Intel
      "snd_intel_dspcfg.dsp_driver=3"
    ];


    initrd.kernelModules = ["thunderbolt" "usbhid" "joydev" "xpad" ];

    loader.efi = {
      #efiSysMountPoint = "/efi"; #this is if you have separate /efi partition
      canTouchEfiVariables = true;
    };

    loader.timeout = 5;

    # Bootloader GRUB
    loader.grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      gfxmodeBios = "auto";
      memtest86.enable = true;
      #  extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
      configurationName = "${host}";
      useOSProber = true;
    };

    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
      magicOrExtension = "\\x7fELF....AI\\x02";
    };
  };

  # GRUB Bootloader theme. Of course you need to enable GRUB above.. duh! and also, enable it on flake.nix
  #distro-grub-themes = {
  #  enable = true;
  #  theme = "nixos";
  #};

  # Extra Module Options
 networking.networkmanager.enable = true;
  networking.hostName = "${host}";
  networking.timeServers = options.networking.timeServers.default
    ++ [ "pool.ntp.org" ];
  networking.firewall.checkReversePath = "loose";
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  services = {
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      desktopManager.runXdgAutostartIfNone = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    libinput.enable = true;

    greetd = {
      enable = true;
      #vt = 3;
      settings = {
        initial_session = {
          user = username;
          command = "start-hyprland";
        };
        default_session = {
          user = username;
          command = "start-hyprland";
        };
      };
    };

    smartd = {
      enable = false;
      autodetect = true;
    };

    gvfs.enable = true;
    tumbler.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    
      raopOpenFirewall = true;

  extraConfig.pipewire = {
    "10-airplay" = {
      "context.modules" = [
        {
          name = "libpipewire-module-raop-discover";
        }
      ];
    };
  };

    };

    fwupd.enable = true;
    avahi.enable = true;

    pulseaudio.enable = false; # unstable
    udev = {
      enable = true;
      packages = [ pkgs.libsigrok ];
      extraRules = ''
        KERNEL=="card*", KERNELS=="0000:00:02.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/intel-card"
        KERNEL=="card*", KERNELS=="0000:2d:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidia-card"
      '';
    };
    dbus.enable = true;

    fstrim = {
      enable = true;
      interval = "weekly";
    };


    rpcbind.enable = false;
    nfs.server.enable = false;

    openssh.enable = true;
    flatpak.enable = true;

    blueman.enable = true;


    upower.enable = true;

    gnome.gnome-keyring.enable = true;

    printing = {
      enable = true;
    #  drivers = [
    # pkgs.hplipWithPlugin
    #  ];
    };
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    withUWSM = true;
  };
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };


  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Cachix, Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };


  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  environment.sessionVariables = {
    WINEPREFIX = "${pkgs.wine}/share/wine";
    WINEARCH = "win64";
    WINE_DPI_SCALE = "3";
  };
}
