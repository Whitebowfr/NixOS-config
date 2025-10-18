# 💫 https://github.com/JaKooLit 💫 #
# Users - NOTE: Packages defined on this will be on current user only

{
  pkgs,
  username,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  users.groups.kvm.members = [ "${username}" ];
  users.groups.libvirtd.members = [ "${username}" ];

  virtualisation.libvirtd = {
    enable = true;
  };

  users = {
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "Whitebowfr";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video"
        "input"
        "audio"
        "dialout"
        "usb"
        "wireshark"
        "plugdev"
      ];

      packages = with pkgs; [
        thunderbird
        jellyflix
        vscode
        libreoffice
        git
        krabby
        discord
        gh
        nextcloud-client
        ungoogled-chromium
        qtcreator
        vmware-horizon-client
        openconnect
        qucs-s
        steam-run
        localsend
        digital
        heroic
        gogdl
        blender
        wineWowPackages.stable
        winetricks
      ];
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb_114;
  };

  programs = {
    spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        enabledExtensions = with spicePkgs.extensions; [
          shuffle
          fullAppDisplayMod
        ];
        enabledCustomApps = with spicePkgs.apps; [
          newReleases
          lyricsPlus
          marketplace
        ];
      };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession.enable = true;
    };

    pulseview.enable = true;

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    hyprland = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

    hyprlock.enable = true;
    git.enable = true;
    nm-applet.indicator = true;

    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [
      exo
      mousepad
      thunar-archive-plugin
      thunar-volman
      tumbler
    ];

    file-roller.enable = true;

    xwayland.enable = true;

    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # rofi = {
    #   enable = true;
    #   package = pkgs.rofi-wayland;
    #   theme = /home/whitebow/.config/rofi/themes/KooL_style-5.rasi;
    #   font = "JetBrainsMono Nerd Font SemiBold 13";
    # };
  };

  # Extra Portal Configuration
  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = false;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-gtk
  #   ];
  #   configPackages = [
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal
  #   ];
  # };
}
