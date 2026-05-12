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
let
unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = config.nixpkgs.config.allowUnfree or false;
  };
in
{
  imports = [
    inputs.spicetify-nix.nixosModules.default
    ./orcaslicer.nix
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
	"gamemode"
      ];

      packages = with pkgs; [
        thunderbird
        vscode
        libreoffice
        git
        krabby
        webcord #discord
        gh
        ungoogled-chromium
        qucs-s
        steam-run
        digital
        heroic
        blender
        wineWowPackages.stable
        winetricks
	art
	freecad
	prismlauncher
	maven
	nodejs_24
	unstable.kicad
	zed-editor
      ];
    };
  };

  programs = {
    nix-ld.enable = true;
    gamemode.enable = true;
    gpu-screen-recorder.enable = true;
    java.enable = true;
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

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      xwayland.enable = true;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

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

    xwayland.enable = true;

    dconf.enable = true;
    dconf.profiles.user.databases = [{
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Flat-Remix-Red-Dark";
      };
    }];
    seahorse.enable = true;
    fuse.userAllowOther = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
