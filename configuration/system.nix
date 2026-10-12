
{ config, pkgs, host, username, options, lib, system, inputs, ... }:
let
  #home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in {
  imports = [
    ./hardware.nix
    ./user.nix
    ./packages.nix
#    ./specialisation.nix
    ./quickshell.nix
    ./terminal.nix
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
  networking.wireless.iwd = {
    enable = true;
    settings = {
      Network = {
        EnableIPv6 = true;
      };
      Settings = {
        AutoConnect = true;
      };
    };
  };
 networking.networkmanager.enable = true;
  systemd.tmpfiles = {
    enable = true;
    rules = let 
      link = "/var/lib/iwd/eduroam.8021x";
      target = "../certs/eduroam.8021x";
    in [
      "L+ ${link} - - - - ${target}"
    ];
  };
  networking.networkmanager.wifi.backend = "iwd";
  networking.hostName = "${host}";
  networking.timeServers = options.networking.timeServers.default
    ++ [ "pool.ntp.org" ];
  networking.firewall.checkReversePath = "loose";
  systemd.services.NetworkManager-wait-online.enable = false;
  time.timeZone = "Europe/Paris"; # Set local timezone

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8" ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
    startplasma-wayland
  '';

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration # Comment out this line if you use KDE Connect
    kdepim-runtime # Unneeded if you use Thunderbird, etc.
    konsole # Comment out this line if you use KDE's default terminal app
    oxygen
    dolphin
    ark
    elisa
    gwenview
    okular
    kate
    dolphin-plugins
    krdp
    kwallet
  ];

  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  environment.systemPackages = lib.mkAfter [
    (pkgs.writeShellScriptBin "nvidia-egpu-check" ''
      #!/usr/bin/env bash
      # Check if RTX eGPU is available and try to detect its bus ID
      echo "=== Thunderbolt Status ==="
      boltctl list 2>/dev/null || echo "boltctl not available"
      
      echo ""
      echo "=== NVIDIA GPU Detection ==="
      if command -v nvidia-smi &> /dev/null; then
        nvidia-smi || echo "nvidia-smi failed - check if driver is loaded"
      else
        echo "nvidia-smi not found"
      fi
      
      echo ""
      echo "=== Kernel Module Status ==="
      lsmod 2>/dev/null | grep -i nvidia || echo "NVIDIA modules not loaded"
      
      echo ""
      echo "=== PCIe Bridge Status ==="
      [ -f /proc/bus/pci/devices ] && grep "80860707\|80860708\|2b:00\|2c:0\|2d:" /proc/bus/pci/devices || echo "PCIe bridge info not available"
      
      echo ""
      echo "=== dmesg NVIDIA Errors ==="
      dmesg 2>/dev/null | grep -i "nvidia\|nvrm" | tail -5 || echo "No recent NVIDIA dmesg entries"
    '')
    (pkgs.writeShellScriptBin "reload-nvidia" ''
      #!/usr/bin/env bash
      set -e
      echo "Reloading NVIDIA kernel modules..."
      sudo modprobe -r nvidia_drm nvidia_modeset nvidia 2>/dev/null || true
      sleep 1
      sudo modprobe nvidia
      sleep 1
      echo "Modules reloaded. Testing nvidia-smi..."
      nvidia-smi || echo "nvidia-smi still unavailable - check dmesg"
    '')
    (pkgs.writeShellScriptBin "plasma-x11-test" ''
      set -euo pipefail

      if [[ -n "''${WAYLAND_DISPLAY:-}" || -n "''${DISPLAY:-}" ]]; then
        echo "Run this from a plain TTY (no DISPLAY/WAYLAND_DISPLAY)."
        exit 1
      fi

      echo "Stopping greetd (releases seat0)..."
      sudo systemctl stop greetd

      cleanup() {
        sudo systemctl start greetd >/dev/null 2>&1 || true
      }
      trap cleanup EXIT

      # Important: start X11 via NixOS' startx integration
      # This creates a proper logind session and fixes input on many setups.
      exec startx ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11
    '')
  ];

  # Services to start
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
    #displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    greetd = {
      enable = true;
      #vt = 3;
      settings = {
        initial_session = {
          user = username;
          command = "start-hyprland";
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
        default_session = {
          user = username;
          command = "start-hyprland";
        };
        #default_session = initial_session;
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
    #envfs.enable = true;
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

  # zram
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };
  services.power-profiles-daemon.enable = true;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  #services.pulseaudio.enable = true; # stable branch

  # Bluetooth
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
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

  # Virtualization / Containers
  #virtualisation.libvirtd.enable = false;
  virtualisation.podman = {
    enable = false;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = false;
  };

  console.keyMap = "us";

  # For Electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  environment.sessionVariables = {
    WINEPREFIX = "${pkgs.wine}/share/wine";
    WINEARCH = "win64";
    WINE_DPI_SCALE = "3";
  };
}
